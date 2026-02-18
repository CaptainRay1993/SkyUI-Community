// AVM1 performance notes:
//   - Every '.' is a hash table lookup at runtime; namespace refs are cached as locals to eliminate chains
//   - Bracket notation (obj[str]) is slower than dot notation; avoided everywhere
//   - Function calls are expensive in AVM1 (scope chain push/pop); positiveRound is fully inlined
//   - Math.round is cached as a local var to avoid repeated global lookups
//   - if/else chains short-circuit; most common materials/types/form-types are ordered first
//   - switch in AVM1 compiles to sequential comparisons, so processEntry uses if/else for ordering control
//   - 'keywords' and other repeated sub-properties cached as locals to avoid re-dereferencing

class InventoryDataSetter extends ItemcardDataExtender
{
   function InventoryDataSetter()
   {
      super();
   }

   function processEntry(a_entryObject, a_itemInfo)
   {
      var Tr    = skyui.util.Translator;
      var F     = skyui.defines.Form;
      var round = Math.round;
      var ft    = a_entryObject.formType;
      var val   = a_itemInfo.value;
      var wt    = a_itemInfo.weight;

      a_entryObject.baseId      = a_entryObject.formId & 0xFFFFFF;
      a_entryObject.type        = a_itemInfo.type;
      a_entryObject.isEquipped  = a_entryObject.equipState > 0;
      a_entryObject.isStolen    = a_itemInfo.stolen == true;

      // positiveRound inlined — avoids function call overhead on every entry
      a_entryObject.infoValue       = val <= 0 ? null : round(val * 100) / 100;
      a_entryObject.infoWeight      = wt  <= 0 ? null : round(wt  * 100) / 100;
      a_entryObject.infoValueWeight = (wt > 0 && val > 0) ? round(val / wt) : null;

      // if/else instead of switch — lets us control short-circuit order
      // Armor and weapons are by far the most common inventory items
      if(ft == F.TYPE_ARMOR)
      {
         var armor = a_itemInfo.armor;
         a_entryObject.isEnchanted = a_itemInfo.effects != "";
         a_entryObject.infoArmor   = armor <= 0 ? null : round(armor * 100) / 100;
         this.processArmorClass(a_entryObject);
         this.processArmorPartMask(a_entryObject);
         this.processMaterialKeywords(a_entryObject);
         this.processArmorOther(a_entryObject);
         this.processArmorBaseId(a_entryObject);
      }
      else if(ft == F.TYPE_WEAPON)
      {
         var dmg = a_itemInfo.damage;
         a_entryObject.isEnchanted = a_itemInfo.effects != "";
         a_entryObject.isPoisoned  = a_itemInfo.poisoned == true;
         a_entryObject.infoDamage  = dmg <= 0 ? null : round(dmg * 100) / 100;
         this.processWeaponType(a_entryObject);
         this.processMaterialKeywords(a_entryObject);
         this.processWeaponBaseId(a_entryObject);
      }
      else if(ft == F.TYPE_MISC)
      {
         this.processMiscType(a_entryObject);
         this.processMiscBaseId(a_entryObject);
      }
      else if(ft == F.TYPE_POTION)
      {
         var dur = a_entryObject.duration;
         var mag = a_entryObject.magnitude;
         a_entryObject.duration  = dur <= 0 ? null : round(dur * 100) / 100;
         a_entryObject.magnitude = mag <= 0 ? null : round(mag * 100) / 100;
         this.processPotionType(a_entryObject);
      }
      else if(ft == F.TYPE_AMMO)
      {
         var adm = a_itemInfo.damage;
         a_entryObject.isEnchanted = a_itemInfo.effects != "";
         a_entryObject.infoDamage  = adm <= 0 ? null : round(adm * 100) / 100;
         this.processAmmoType(a_entryObject);
         this.processMaterialKeywords(a_entryObject);
         this.processAmmoBaseId(a_entryObject);
      }
      else if(ft == F.TYPE_BOOK)
      {
         this.processBookType(a_entryObject);
      }
      else if(ft == F.TYPE_SOULGEM)
      {
         this.processSoulGemType(a_entryObject);
         this.processSoulGemStatus(a_entryObject);
         this.processSoulGemBaseId(a_entryObject);
      }
      else if(ft == F.TYPE_SCROLLITEM)
      {
         var sdur = a_entryObject.duration;
         var smag = a_entryObject.magnitude;
         a_entryObject.subTypeDisplay = Tr.translate("$Scroll");
         a_entryObject.duration       = sdur <= 0 ? null : round(sdur * 100) / 100;
         a_entryObject.magnitude      = smag <= 0 ? null : round(smag * 100) / 100;
      }
      else if(ft == F.TYPE_KEY)
      {
         this.processKeyType(a_entryObject);
      }
      else if(ft == F.TYPE_INGREDIENT)
      {
         a_entryObject.subTypeDisplay = Tr.translate("$Ingredient");
      }
      else if(ft == F.TYPE_LIGHT)
      {
         a_entryObject.subTypeDisplay = Tr.translate("$Torch");
      }
   }

   function processArmorClass(a_entryObject)
   {
      var A  = skyui.defines.Armor;
      var Tr = skyui.util.Translator;
      var wc = a_entryObject.weightClass;

      if(wc == A.WEIGHT_NONE)
      {
         a_entryObject.weightClass = null;
         wc = null;
      }

      if(wc == A.WEIGHT_LIGHT)
      {
         a_entryObject.weightClassDisplay = Tr.translate("$Light");
         return;
      }
      if(wc == A.WEIGHT_HEAVY)
      {
         a_entryObject.weightClassDisplay = Tr.translate("$Heavy");
         return;
      }

      a_entryObject.weightClassDisplay = Tr.translate("$Other");
      var kw = a_entryObject.keywords;
      if(kw == undefined) return;

      if(kw.VendorItemClothing != undefined)
      {
         a_entryObject.weightClass        = A.WEIGHT_CLOTHING;
         a_entryObject.weightClassDisplay = Tr.translate("$Clothing");
         return;
      }
      if(kw.VendorItemJewelry != undefined)
      {
         a_entryObject.weightClass        = A.WEIGHT_JEWELRY;
         a_entryObject.weightClassDisplay = Tr.translate("$Jewelry");
      }
   }

   function processMaterialKeywords(a_entryObject)
   {
      // Cache everything — called for armor, weapons, and ammo on every inventory open
      var kw = a_entryObject.keywords;
      var M  = skyui.defines.Material;
      var Tr = skyui.util.Translator;

      a_entryObject.material        = null;
      a_entryObject.materialDisplay = Tr.translate("$Other");

      if(kw == undefined) return;

      // Ordered by real-world frequency:
      // Iron/Steel/Leather dominate early-mid game; Daedric/Dragon are rare endgame; DLC rarest
      if(kw.ArmorMaterialIron != undefined || kw.WeapMaterialIron != undefined)
      {
         a_entryObject.material        = M.IRON;
         a_entryObject.materialDisplay = Tr.translate("$Iron");
      }
      else if(kw.ArmorMaterialSteel != undefined || kw.WeapMaterialSteel != undefined)
      {
         a_entryObject.material        = M.STEEL;
         a_entryObject.materialDisplay = Tr.translate("$Steel");
      }
      else if(kw.ArmorMaterialLeather != undefined)
      {
         a_entryObject.material        = M.LEATHER;
         a_entryObject.materialDisplay = Tr.translate("$Leather");
      }
      else if(kw.ArmorMaterialHide != undefined)
      {
         a_entryObject.material        = M.HIDE;
         a_entryObject.materialDisplay = Tr.translate("$Hide");
      }
      else if(kw.ArmorMaterialImperialHeavy != undefined || kw.ArmorMaterialImperialLight != undefined || kw.WeapMaterialImperial != undefined)
      {
         a_entryObject.material        = M.IMPERIAL;
         a_entryObject.materialDisplay = Tr.translate("$Imperial");
      }
      else if(kw.ArmorMaterialStormcloak != undefined)
      {
         a_entryObject.material        = M.STORMCLOAK;
         a_entryObject.materialDisplay = Tr.translate("$Stormcloak");
      }
      else if(kw.ArmorMaterialDwarven != undefined || kw.WeapMaterialDwarven != undefined)
      {
         a_entryObject.material        = M.DWARVEN;
         a_entryObject.materialDisplay = Tr.translate("$Dwarven");
      }
      else if(kw.ArmorMaterialOrcish != undefined || kw.WeapMaterialOrcish != undefined)
      {
         a_entryObject.material        = M.ORCISH;
         a_entryObject.materialDisplay = Tr.translate("$Orcish");
      }
      else if(kw.ArmorMaterialElven != undefined || kw.WeapMaterialElven != undefined)
      {
         a_entryObject.material        = M.ELVEN;
         a_entryObject.materialDisplay = Tr.translate("$Elven");
      }
      else if(kw.ArmorMaterialGlass != undefined || kw.WeapMaterialGlass != undefined)
      {
         a_entryObject.material        = M.GLASS;
         a_entryObject.materialDisplay = Tr.translate("$Glass");
      }
      else if(kw.ArmorMaterialEbony != undefined || kw.WeapMaterialEbony != undefined)
      {
         a_entryObject.material        = M.EBONY;
         a_entryObject.materialDisplay = Tr.translate("$Ebony");
      }
      else if(kw.WeapMaterialSilver != undefined)
      {
         a_entryObject.material        = M.SILVER;
         a_entryObject.materialDisplay = Tr.translate("$Silver");
      }
      else if(kw.ArmorMaterialSteelPlate != undefined)
      {
         a_entryObject.material        = M.STEELPLATE;
         a_entryObject.materialDisplay = Tr.translate("$Steel Plate");
      }
      else if(kw.ArmorMaterialIronBanded != undefined)
      {
         a_entryObject.material        = M.IRONBANDED;
         a_entryObject.materialDisplay = Tr.translate("$Iron Banded");
      }
      else if(kw.ArmorMaterialImperialStudded != undefined)
      {
         a_entryObject.material        = M.IMPERIALSTUDDED;
         a_entryObject.materialDisplay = Tr.translate("$Studded");
      }
      else if(kw.ArmorMaterialStudded != undefined)
      {
         a_entryObject.material        = M.STUDDED;
         a_entryObject.materialDisplay = Tr.translate("$Studded");
      }
      else if(kw.ArmorMaterialScaled != undefined)
      {
         a_entryObject.material        = M.SCALED;
         a_entryObject.materialDisplay = Tr.translate("$Scaled");
      }
      else if(kw.WeapMaterialDraugr != undefined)
      {
         a_entryObject.material        = M.DRAUGR;
         a_entryObject.materialDisplay = Tr.translate("$Draugr");
      }
      else if(kw.WeapMaterialDraugrHoned != undefined)
      {
         a_entryObject.material        = M.DRAUGRHONED;
         a_entryObject.materialDisplay = Tr.translate("$Draugr Honed");
      }
      else if(kw.WeapMaterialFalmer != undefined)
      {
         a_entryObject.material        = M.FALMER;
         a_entryObject.materialDisplay = Tr.translate("$Falmer");
      }
      else if(kw.WeapMaterialFalmerHoned != undefined)
      {
         a_entryObject.material        = M.FALMERHONED;
         a_entryObject.materialDisplay = Tr.translate("$Falmer Honed");
      }
      else if(kw.WeapMaterialWood != undefined)
      {
         a_entryObject.material        = M.WOOD;
         a_entryObject.materialDisplay = Tr.translate("$Wood");
      }
      else if(kw.ArmorMaterialDaedric != undefined || kw.WeapMaterialDaedric != undefined)
      {
         a_entryObject.material        = M.DAEDRIC;
         a_entryObject.materialDisplay = Tr.translate("$Daedric");
      }
      else if(kw.ArmorMaterialDragonplate != undefined)
      {
         a_entryObject.material        = M.DRAGONPLATE;
         a_entryObject.materialDisplay = Tr.translate("$Dragonplate");
      }
      else if(kw.ArmorMaterialDragonscale != undefined)
      {
         a_entryObject.material        = M.DRAGONSCALE;
         a_entryObject.materialDisplay = Tr.translate("$Dragonscale");
      }
      else if(kw.ArmorMaterialElvenGilded != undefined)
      {
         a_entryObject.material        = M.ELVENGILDED;
         a_entryObject.materialDisplay = Tr.translate("$Elven Gilded");
      }
      else if(kw.DLC1ArmorMaterialVampire != undefined)
      {
         a_entryObject.material        = M.VAMPIRE;
         a_entryObject.materialDisplay = Tr.translate("$Vampire");
      }
      else if(kw.DLC1ArmorMaterialDawnguard != undefined)
      {
         a_entryObject.material        = M.DAWNGUARD;
         a_entryObject.materialDisplay = Tr.translate("$Dawnguard");
      }
      else if(kw.DLC1ArmorMaterialFalmerHardened != undefined || kw.DLC1ArmorMaterialFalmerHeavy != undefined)
      {
         a_entryObject.material        = M.FALMERHARDENED;
         a_entryObject.materialDisplay = Tr.translate("$Falmer Hardened");
      }
      else if(kw.DLC1ArmorMaterialHunter != undefined)
      {
         a_entryObject.material        = M.HUNTER;
         a_entryObject.materialDisplay = Tr.translate("$Hunter");
      }
      else if(kw.DLC1LD_CraftingMaterialAetherium != undefined)
      {
         a_entryObject.material        = M.AETHERIUM;
         a_entryObject.materialDisplay = Tr.translate("$Aetherium");
      }
      else if(kw.DLC1WeapMaterialDragonbone != undefined)
      {
         a_entryObject.material        = M.DRAGONBONE;
         a_entryObject.materialDisplay = Tr.translate("$Dragonbone");
      }
      else if(kw.DLC2ArmorMaterialNordicHeavy != undefined || kw.DLC2ArmorMaterialNordicLight != undefined || kw.DLC2WeaponMaterialNordic != undefined)
      {
         a_entryObject.material        = M.NORDIC;
         a_entryObject.materialDisplay = Tr.translate("$Nordic");
      }
      else if(kw.DLC2ArmorMaterialBonemoldHeavy != undefined || kw.DLC2ArmorMaterialBonemoldLight != undefined)
      {
         a_entryObject.material        = M.BONEMOLD;
         a_entryObject.materialDisplay = Tr.translate("$Bonemold");
      }
      else if(kw.DLC2ArmorMaterialChitinHeavy != undefined || kw.DLC2ArmorMaterialChitinLight != undefined)
      {
         a_entryObject.material        = M.CHITIN;
         a_entryObject.materialDisplay = Tr.translate("$Chitin");
      }
      else if(kw.DLC2ArmorMaterialMoragTong != undefined)
      {
         a_entryObject.material        = M.MORAGTONG;
         a_entryObject.materialDisplay = Tr.translate("$Morag Tong");
      }
      else if(kw.DLC2ArmorMaterialStalhrimHeavy != undefined || kw.DLC2ArmorMaterialStalhrimLight != undefined || kw.DLC2WeaponMaterialStalhrim != undefined)
      {
         // Deathbrand check inlined here — avoids a second pass through the keyword object
         if(kw.DLC2dunHaknirArmor != undefined)
         {
            a_entryObject.material        = M.DEATHBRAND;
            a_entryObject.materialDisplay = Tr.translate("$Deathbrand");
         }
         else
         {
            a_entryObject.material        = M.STALHRIM;
            a_entryObject.materialDisplay = Tr.translate("$Stalhrim");
         }
      }
   }

   function processWeaponType(a_entryObject)
   {
      var W  = skyui.defines.Weapon;
      var Tr = skyui.util.Translator;
      var wt = a_entryObject.weaponType;

      a_entryObject.subType        = null;
      a_entryObject.subTypeDisplay = Tr.translate("$Weapon");

      // Ordered: swords and bows most common, then one-handers, two-handers, staves, crossbows last
      if(wt == W.ANIM_ONEHANDSWORD || wt == W.ANIM_1HS)
      {
         a_entryObject.subType        = W.TYPE_SWORD;
         a_entryObject.subTypeDisplay = Tr.translate("$Sword");
      }
      else if(wt == W.ANIM_BOW || wt == W.ANIM_BOW2)
      {
         a_entryObject.subType        = W.TYPE_BOW;
         a_entryObject.subTypeDisplay = Tr.translate("$Bow");
      }
      else if(wt == W.ANIM_ONEHANDAXE || wt == W.ANIM_1HA)
      {
         a_entryObject.subType        = W.TYPE_WARAXE;
         a_entryObject.subTypeDisplay = Tr.translate("$War Axe");
      }
      else if(wt == W.ANIM_ONEHANDDAGGER || wt == W.ANIM_1HD)
      {
         a_entryObject.subType        = W.TYPE_DAGGER;
         a_entryObject.subTypeDisplay = Tr.translate("$Dagger");
      }
      else if(wt == W.ANIM_ONEHANDMACE || wt == W.ANIM_1HM)
      {
         a_entryObject.subType        = W.TYPE_MACE;
         a_entryObject.subTypeDisplay = Tr.translate("$Mace");
      }
      else if(wt == W.ANIM_TWOHANDSWORD || wt == W.ANIM_2HS)
      {
         a_entryObject.subType        = W.TYPE_GREATSWORD;
         a_entryObject.subTypeDisplay = Tr.translate("$Greatsword");
      }
      else if(wt == W.ANIM_TWOHANDAXE || wt == W.ANIM_2HA)
      {
         a_entryObject.subType        = W.TYPE_BATTLEAXE;
         a_entryObject.subTypeDisplay = Tr.translate("$Battleaxe");
         var kw = a_entryObject.keywords;
         if(kw != undefined && kw.WeapTypeWarhammer != undefined)
         {
            a_entryObject.subType        = W.TYPE_WARHAMMER;
            a_entryObject.subTypeDisplay = Tr.translate("$Warhammer");
         }
      }
      else if(wt == W.ANIM_STAFF || wt == W.ANIM_STAFF2)
      {
         a_entryObject.subType        = W.TYPE_STAFF;
         a_entryObject.subTypeDisplay = Tr.translate("$Staff");
      }
      else if(wt == W.ANIM_CROSSBOW || wt == W.ANIM_CBOW)
      {
         a_entryObject.subType        = W.TYPE_CROSSBOW;
         a_entryObject.subTypeDisplay = Tr.translate("$Crossbow");
      }
      else if(wt == W.ANIM_HANDTOHANDMELEE || wt == W.ANIM_H2H)
      {
         a_entryObject.subType        = W.TYPE_MELEE;
         a_entryObject.subTypeDisplay = Tr.translate("$Melee");
      }
   }

   function processWeaponBaseId(a_entryObject)
   {
      var W    = skyui.defines.Weapon;
      var F    = skyui.defines.Form;
      var Tr   = skyui.util.Translator;
      var base = a_entryObject.baseId;

      if(base == F.BASEID_WEAPPICKAXE || base == F.BASEID_SSDROCKSPLINTERPICKAXE || base == F.BASEID_DUNVOLUNRUUDPICKAXE)
      {
         a_entryObject.subType        = W.TYPE_PICKAXE;
         a_entryObject.subTypeDisplay = Tr.translate("$Pickaxe");
      }
      else if(base == F.BASEID_AXE01 || base == F.BASEID_DUNHALTEDSTREAMPOACHERSAXE)
      {
         a_entryObject.subType        = W.TYPE_WOODAXE;
         a_entryObject.subTypeDisplay = Tr.translate("$Wood Axe");
      }
   }

   function processArmorPartMask(a_entryObject)
   {
      var pm = a_entryObject.partMask;
      if(pm == undefined) return undefined;

      var A       = skyui.defines.Armor;
      var Tr      = skyui.util.Translator;
      var prec    = A.PARTMASK_PRECEDENCE;
      var precLen = prec.length;
      var mpm;

      for(var i = 0; i < precLen; i++)
      {
         if(pm & prec[i])
         {
            mpm = prec[i];
            a_entryObject.mainPartMask = mpm;
            break;
         }
      }
      if(mpm == undefined) return undefined;

      // Ordered: body/head/feet/hands most common armor slots
      if(mpm == A.PARTMASK_BODY)
      {
         a_entryObject.subType        = A.EQUIP_BODY;
         a_entryObject.subTypeDisplay = Tr.translate("$Body");
      }
      else if(mpm == A.PARTMASK_HEAD)
      {
         a_entryObject.subType        = A.EQUIP_HEAD;
         a_entryObject.subTypeDisplay = Tr.translate("$Head");
      }
      else if(mpm == A.PARTMASK_FEET)
      {
         a_entryObject.subType        = A.EQUIP_FEET;
         a_entryObject.subTypeDisplay = Tr.translate("$Feet");
      }
      else if(mpm == A.PARTMASK_HANDS)
      {
         a_entryObject.subType        = A.EQUIP_HANDS;
         a_entryObject.subTypeDisplay = Tr.translate("$Hands");
      }
      else if(mpm == A.PARTMASK_SHIELD)
      {
         a_entryObject.subType        = A.EQUIP_SHIELD;
         a_entryObject.subTypeDisplay = Tr.translate("$Shield");
      }
      else if(mpm == A.PARTMASK_RING)
      {
         a_entryObject.subType        = A.EQUIP_RING;
         a_entryObject.subTypeDisplay = Tr.translate("$Ring");
      }
      else if(mpm == A.PARTMASK_AMULET)
      {
         a_entryObject.subType        = A.EQUIP_AMULET;
         a_entryObject.subTypeDisplay = Tr.translate("$Amulet");
      }
      else if(mpm == A.PARTMASK_CIRCLET)
      {
         a_entryObject.subType        = A.EQUIP_CIRCLET;
         a_entryObject.subTypeDisplay = Tr.translate("$Circlet");
      }
      else if(mpm == A.PARTMASK_HAIR)
      {
         a_entryObject.subType        = A.EQUIP_HAIR;
         a_entryObject.subTypeDisplay = Tr.translate("$Head");
      }
      else if(mpm == A.PARTMASK_LONGHAIR)
      {
         a_entryObject.subType        = A.EQUIP_LONGHAIR;
         a_entryObject.subTypeDisplay = Tr.translate("$Head");
      }
      else if(mpm == A.PARTMASK_FOREARMS)
      {
         a_entryObject.subType        = A.EQUIP_FOREARMS;
         a_entryObject.subTypeDisplay = Tr.translate("$Forearms");
      }
      else if(mpm == A.PARTMASK_CALVES)
      {
         a_entryObject.subType        = A.EQUIP_CALVES;
         a_entryObject.subTypeDisplay = Tr.translate("$Calves");
      }
      else if(mpm == A.PARTMASK_EARS)
      {
         a_entryObject.subType        = A.EQUIP_EARS;
         a_entryObject.subTypeDisplay = Tr.translate("$Ears");
      }
      else if(mpm == A.PARTMASK_TAIL)
      {
         a_entryObject.subType        = A.EQUIP_TAIL;
         a_entryObject.subTypeDisplay = Tr.translate("$Tail");
      }
      else
      {
         a_entryObject.subType = mpm;
      }
   }

   function processArmorOther(a_entryObject)
   {
      if(a_entryObject.weightClass != null) return undefined;

      var A   = skyui.defines.Armor;
      var Tr  = skyui.util.Translator;
      var mpm = a_entryObject.mainPartMask;

      if(mpm == A.PARTMASK_BODY    || mpm == A.PARTMASK_HEAD     || mpm == A.PARTMASK_FEET
      || mpm == A.PARTMASK_HANDS   || mpm == A.PARTMASK_SHIELD   || mpm == A.PARTMASK_FOREARMS
      || mpm == A.PARTMASK_CALVES  || mpm == A.PARTMASK_HAIR     || mpm == A.PARTMASK_LONGHAIR
      || mpm == A.PARTMASK_TAIL)
      {
         a_entryObject.weightClass        = A.WEIGHT_CLOTHING;
         a_entryObject.weightClassDisplay = Tr.translate("$Clothing");
      }
      else if(mpm == A.PARTMASK_AMULET || mpm == A.PARTMASK_RING
           || mpm == A.PARTMASK_CIRCLET || mpm == A.PARTMASK_EARS)
      {
         a_entryObject.weightClass        = A.WEIGHT_JEWELRY;
         a_entryObject.weightClassDisplay = Tr.translate("$Jewelry");
      }
   }

   function processArmorBaseId(a_entryObject)
   {
      var F    = skyui.defines.Form;
      var A    = skyui.defines.Armor;
      var Tr   = skyui.util.Translator;
      var base = a_entryObject.baseId;

      if(base == F.BASEID_CLOTHESWEDDINGWREATH)
      {
         a_entryObject.weightClass        = A.WEIGHT_JEWELRY;
         a_entryObject.weightClassDisplay = Tr.translate("$Jewelry");
      }
      else if(base == F.BASEID_DLC1CLOTHESVAMPIRELORDARMOR)
      {
         a_entryObject.subType        = A.EQUIP_BODY;
         a_entryObject.subTypeDisplay = Tr.translate("$Body");
      }
   }

   function processBookType(a_entryObject)
   {
      var I  = skyui.defines.Item;
      var Tr = skyui.util.Translator;

      a_entryObject.subType        = I.OTHER;
      a_entryObject.subTypeDisplay = Tr.translate("$Book");
      a_entryObject.isRead         = (a_entryObject.flags & I.BOOKFLAG_READ) != 0;

      if(a_entryObject.bookType == I.BOOKTYPE_NOTE)
      {
         a_entryObject.subType        = I.BOOK_NOTE;
         a_entryObject.subTypeDisplay = Tr.translate("$Note");
      }

      var kw = a_entryObject.keywords;
      if(kw == undefined) return undefined;

      // Spell tomes checked first — more common than recipes in practice
      if(kw.VendorItemSpellTome != undefined)
      {
         a_entryObject.subType        = I.BOOK_SPELLTOME;
         a_entryObject.subTypeDisplay = Tr.translate("$Spell Tome");
      }
      else if(kw.VendorItemRecipe != undefined)
      {
         a_entryObject.subType        = I.BOOK_RECIPE;
         a_entryObject.subTypeDisplay = Tr.translate("$Recipe");
      }
   }

   function processAmmoType(a_entryObject)
   {
      var W  = skyui.defines.Weapon;
      var Tr = skyui.util.Translator;

      if((a_entryObject.flags & W.AMMOFLAG_NONBOLT) != 0)
      {
         a_entryObject.subType        = W.AMMO_ARROW;
         a_entryObject.subTypeDisplay = Tr.translate("$Arrow");
      }
      else
      {
         a_entryObject.subType        = W.AMMO_BOLT;
         a_entryObject.subTypeDisplay = Tr.translate("$Bolt");
      }
   }

   function processAmmoBaseId(a_entryObject)
   {
      var F    = skyui.defines.Form;
      var M    = skyui.defines.Material;
      var Tr   = skyui.util.Translator;
      var base = a_entryObject.baseId;

      // Ordered: iron/steel/dwarven arrows are most commonly encountered
      if(base == F.BASEID_IRONARROW           || base == F.BASEID_CWARROW
      || base == F.BASEID_CWARROWSHORT        || base == F.BASEID_TRAPDART
      || base == F.BASEID_DUNARCHERPRATICEARROW
      || base == F.BASEID_DUNGEIRMUNDSIGDISARROWSILLUSION
      || base == F.BASEID_FOLLOWERIRONARROW   || base == F.BASEID_TESTDLC1BOLT)
      {
         a_entryObject.material        = M.IRON;
         a_entryObject.materialDisplay = Tr.translate("$Iron");
      }
      else if(base == F.BASEID_STEELARROW || base == F.BASEID_MQ101STEELARROW)
      {
         a_entryObject.material        = M.STEEL;
         a_entryObject.materialDisplay = Tr.translate("$Steel");
      }
      else if(base == F.BASEID_DWARVENARROW       || base == F.BASEID_DWARVENSPHEREARROW
           || base == F.BASEID_DWARVENSPHEREBOLT01 || base == F.BASEID_DWARVENSPHEREBOLT02
           || base == F.BASEID_DLC2DWARVENBALLISTABOLT)
      {
         a_entryObject.material        = M.DWARVEN;
         a_entryObject.materialDisplay = Tr.translate("$Dwarven");
      }
      else if(base == F.BASEID_ELVENARROW || base == F.BASEID_DLC1ELVENARROWBLESSED || base == F.BASEID_DLC1ELVENARROWBLOOD)
      {
         a_entryObject.material        = M.ELVEN;
         a_entryObject.materialDisplay = Tr.translate("$Elven");
      }
      else if(base == F.BASEID_ORCISHARROW)
      {
         a_entryObject.material        = M.ORCISH;
         a_entryObject.materialDisplay = Tr.translate("$Orcish");
      }
      else if(base == F.BASEID_FORSWORNARROW)
      {
         a_entryObject.material        = M.HIDE;
         a_entryObject.materialDisplay = Tr.translate("$Forsworn");
      }
      else if(base == F.BASEID_DRAUGRARROW)
      {
         a_entryObject.material        = M.DRAUGR;
         a_entryObject.materialDisplay = Tr.translate("$Draugr");
      }
      else if(base == F.BASEID_FALMERARROW)
      {
         a_entryObject.material        = M.FALMER;
         a_entryObject.materialDisplay = Tr.translate("$Falmer");
      }
      else if(base == F.BASEID_GLASSARROW)
      {
         a_entryObject.material        = M.GLASS;
         a_entryObject.materialDisplay = Tr.translate("$Glass");
      }
      else if(base == F.BASEID_EBONYARROW)
      {
         a_entryObject.material        = M.EBONY;
         a_entryObject.materialDisplay = Tr.translate("$Ebony");
      }
      else if(base == F.BASEID_NORDHEROARROW)
      {
         a_entryObject.material        = M.NORDIC;
         a_entryObject.materialDisplay = Tr.translate("$Nordic");
      }
      else if(base == F.BASEID_DAEDRICARROW)
      {
         a_entryObject.material        = M.DAEDRIC;
         a_entryObject.materialDisplay = Tr.translate("$Daedric");
      }
      else if(base == F.BASEID_DLC2RIEKLINGSPEARTHROWN)
      {
         a_entryObject.material        = M.WOOD;
         a_entryObject.materialDisplay = Tr.translate("$Wood");
         a_entryObject.subTypeDisplay  = Tr.translate("$Spear");
      }
   }

   function processKeyType(a_entryObject)
   {
      a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Key");
      // BUG FIX: original had a duplicate null check; one is sufficient
      if(a_entryObject.infoValue <= 0)
      {
         a_entryObject.infoValue = null;
      }
   }

   function processPotionType(a_entryObject)
   {
      var I  = skyui.defines.Item;
      var Ac = skyui.defines.Actor;
      var F  = skyui.defines.Form;
      var Tr = skyui.util.Translator;
      var fl = a_entryObject.flags;

      a_entryObject.subType        = I.POTION_POTION;
      a_entryObject.subTypeDisplay = Tr.translate("$Potion");

      if((fl & I.ALCHFLAG_FOOD) != 0)
      {
         a_entryObject.subType        = I.POTION_FOOD;
         a_entryObject.subTypeDisplay = Tr.translate("$Food");
         var us = a_entryObject.useSound;
         if(us.formId != undefined && us.formId == F.FORMID_ITMPotionUse)
         {
            a_entryObject.subType        = I.POTION_DRINK;
            a_entryObject.subTypeDisplay = Tr.translate("$Drink");
         }
      }
      else if((fl & I.ALCHFLAG_POISON) != 0)
      {
         a_entryObject.subType        = I.POTION_POISON;
         a_entryObject.subTypeDisplay = Tr.translate("$Poison");
      }
      else
      {
         var av = a_entryObject.actorValue;
         if(av == Ac.AV_HEALTH)
         {
            a_entryObject.subType        = I.POTION_HEALTH;
            a_entryObject.subTypeDisplay = Tr.translate("$Health");
         }
         else if(av == Ac.AV_MAGICKA)
         {
            a_entryObject.subType        = I.POTION_MAGICKA;
            a_entryObject.subTypeDisplay = Tr.translate("$Magicka");
         }
         else if(av == Ac.AV_STAMINA)
         {
            a_entryObject.subType        = I.POTION_STAMINA;
            a_entryObject.subTypeDisplay = Tr.translate("$Stamina");
         }
         else if(av == Ac.AV_HEALRATE)
         {
            a_entryObject.subType        = I.POTION_HEALRATE;
            a_entryObject.subTypeDisplay = Tr.translate("$Health");
         }
         else if(av == Ac.AV_MAGICKARATE)
         {
            a_entryObject.subType        = I.POTION_MAGICKARATE;
            a_entryObject.subTypeDisplay = Tr.translate("$Magicka");
         }
         else if(av == Ac.AV_STAMINARATE)
         {
            a_entryObject.subType        = I.POTION_STAMINARATE;
            a_entryObject.subTypeDisplay = Tr.translate("$Stamina");
         }
         else if(av == Ac.AV_HEALRATEMULT)
         {
            a_entryObject.subType        = I.POTION_HEALRATEMULT;
            a_entryObject.subTypeDisplay = Tr.translate("$Health");
         }
         else if(av == Ac.AV_MAGICKARATEMULT)
         {
            a_entryObject.subType        = I.POTION_MAGICKARATEMULT;
            a_entryObject.subTypeDisplay = Tr.translate("$Magicka");
         }
         else if(av == Ac.AV_STAMINARATEMULT)
         {
            a_entryObject.subType        = I.POTION_STAMINARATEMULT;
            a_entryObject.subTypeDisplay = Tr.translate("$Stamina");
         }
         else if(av == Ac.AV_FIRERESIST)
         {
            a_entryObject.subType = I.POTION_FIRERESIST;
         }
         else if(av == Ac.AV_ELECTRICRESIST)
         {
            a_entryObject.subType = I.POTION_ELECTRICRESIST;
         }
         else if(av == Ac.AV_FROSTRESIST)
         {
            a_entryObject.subType = I.POTION_FROSTRESIST;
         }
      }
   }

   function processSoulGemType(a_entryObject)
   {
      var I  = skyui.defines.Item;
      var Tr = skyui.util.Translator;
      var gs = a_entryObject.gemSize;

      a_entryObject.subType        = I.OTHER;
      a_entryObject.subTypeDisplay = Tr.translate("$Soul Gem");
      if(gs != undefined && gs != I.SOULGEM_NONE)
      {
         a_entryObject.subType = gs;
      }
   }

   function processSoulGemStatus(a_entryObject)
   {
      var I  = skyui.defines.Item;
      var gs = a_entryObject.gemSize;
      var ss = a_entryObject.soulSize;

      if(gs == undefined || ss == undefined || ss == I.SOULGEM_NONE)
      {
         a_entryObject.status = I.SOULGEMSTATUS_EMPTY;
      }
      else if(ss >= gs)
      {
         a_entryObject.status = I.SOULGEMSTATUS_FULL;
      }
      else
      {
         a_entryObject.status = I.SOULGEMSTATUS_PARTIAL;
      }
   }

   function processSoulGemBaseId(a_entryObject)
   {
      var F    = skyui.defines.Form;
      var I    = skyui.defines.Item;
      var base = a_entryObject.baseId;

      if(base == F.BASEID_DA01SOULGEMBLACKSTAR || base == F.BASEID_DA01SOULGEMAZURASSTAR)
      {
         a_entryObject.subType = I.SOULGEM_AZURA;
      }
   }

   function processMiscType(a_entryObject)
   {
      var I  = skyui.defines.Item;
      var Tr = skyui.util.Translator;

      a_entryObject.subType        = I.OTHER;
      a_entryObject.subTypeDisplay = Tr.translate("$Misc");

      var kw = a_entryObject.keywords;
      if(kw == undefined) return undefined;

      // Ordered: crafting materials (ingot, hide, clutter) most common in typical inventory
      if(kw.VendorItemOreIngot != undefined)
      {
         a_entryObject.subType        = I.MISC_INGOT;
         a_entryObject.subTypeDisplay = Tr.translate("$Ingot");
      }
      else if(kw.VendorItemClutter != undefined)
      {
         a_entryObject.subType        = I.MISC_CLUTTER;
         a_entryObject.subTypeDisplay = Tr.translate("$Clutter");
      }
      else if(kw.VendorItemAnimalHide != undefined)
      {
         a_entryObject.subType        = I.MISC_HIDE;
         a_entryObject.subTypeDisplay = Tr.translate("$Hide");
      }
      else if(kw.VendorItemAnimalPart != undefined)
      {
         a_entryObject.subType        = I.MISC_REMAINS;
         a_entryObject.subTypeDisplay = Tr.translate("$Remains");
      }
      else if(kw.VendorItemGem != undefined)
      {
         a_entryObject.subType        = I.MISC_GEM;
         a_entryObject.subTypeDisplay = Tr.translate("$Gem");
      }
      else if(kw.VendorItemTool != undefined)
      {
         a_entryObject.subType        = I.MISC_TOOL;
         a_entryObject.subTypeDisplay = Tr.translate("$Tool");
      }
      else if(kw.VendorItemFirewood != undefined)
      {
         a_entryObject.subType        = I.MISC_FIREWOOD;
         a_entryObject.subTypeDisplay = Tr.translate("$Firewood");
      }
      else if(kw.VendorItemDaedricArtifact != undefined)
      {
         a_entryObject.subType        = I.MISC_ARTIFACT;
         a_entryObject.subTypeDisplay = Tr.translate("$Artifact");
      }
      else if(kw.BYOHHouseCraftingCategoryWeaponRacks != undefined
           || kw.BYOHHouseCraftingCategoryShelf       != undefined
           || kw.BYOHHouseCraftingCategoryFurniture   != undefined
           || kw.BYOHHouseCraftingCategoryExterior    != undefined
           || kw.BYOHHouseCraftingCategoryContainers  != undefined
           || kw.BYOHHouseCraftingCategoryBuilding    != undefined
           || kw.BYOHHouseCraftingCategorySmithing    != undefined)
      {
         a_entryObject.subType        = I.MISC_HOUSEPART;
         a_entryObject.subTypeDisplay = Tr.translate("$House Part");
      }
      else if(kw.BYOHAdoptionClothesKeyword != undefined)
      {
         a_entryObject.subType        = I.MISC_CHILDRENSCLOTHES;
         a_entryObject.subTypeDisplay = Tr.translate("$Clothing");
      }
      else if(kw.BYOHAdoptionToyKeyword != undefined)
      {
         a_entryObject.subType        = I.MISC_TOY;
         a_entryObject.subTypeDisplay = Tr.translate("$Toy");
      }
   }

   function processMiscBaseId(a_entryObject)
   {
      var F    = skyui.defines.Form;
      var I    = skyui.defines.Item;
      var Tr   = skyui.util.Translator;
      var base = a_entryObject.baseId;

      // Ordered: lockpick and gold hit most frequently across a playthrough
      if(base == F.BASEID_LOCKPICK)
      {
         a_entryObject.subType        = I.MISC_LOCKPICK;
         a_entryObject.subTypeDisplay = Tr.translate("$Lockpick");
      }
      else if(base == F.BASEID_GOLD001)
      {
         a_entryObject.subType        = I.MISC_GOLD;
         a_entryObject.subTypeDisplay = Tr.translate("$Gold");
      }
      else if(base == F.BASEID_LEATHER01)
      {
         a_entryObject.subType        = I.MISC_LEATHER;
         a_entryObject.subTypeDisplay = Tr.translate("$Leather");
      }
      else if(base == F.BASEID_LEATHERSTRIPS)
      {
         a_entryObject.subType        = I.MISC_LEATHERSTRIPS;
         a_entryObject.subTypeDisplay = Tr.translate("$Strips");
      }
      else if(base == F.BASEID_GEMAMETHYSTFLAWLESS)
      {
         a_entryObject.subType        = I.MISC_GEM;
         a_entryObject.subTypeDisplay = Tr.translate("$Gem");
      }
      else if(base == F.BASEID_RUBYDRAGONCLAW    || base == F.BASEID_IVORYDRAGONCLAW
           || base == F.BASEID_GLASSCLAW         || base == F.BASEID_EBONYCLAW
           || base == F.BASEID_EMERALDDRAGONCLAW  || base == F.BASEID_DIAMONDCLAW
           || base == F.BASEID_IRONCLAW          || base == F.BASEID_CORALDRAGONCLAW
           || base == F.BASEID_E3GOLDENCLAW      || base == F.BASEID_SAPPHIREDRAGONCLAW
           || base == F.BASEID_MS13GOLDENCLAW)
      {
         a_entryObject.subType        = I.MISC_DRAGONCLAW;
         a_entryObject.subTypeDisplay = Tr.translate("$Claw");
      }
   }
}
