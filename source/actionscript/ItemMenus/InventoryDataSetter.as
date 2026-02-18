class InventoryDataSetter extends ItemcardDataExtender
{
   // Data-driven material keyword table.
   // Each entry: [ [keyword, ...], material constant, display translation key ]
   // Order matches original if/else precedence — do not reorder.
   static var MATERIAL_KEYWORD_TABLE = [
      [["ArmorMaterialDaedric","WeapMaterialDaedric"],                                                   skyui.defines.Material.DAEDRIC,         "$Daedric"],
      [["ArmorMaterialDragonplate"],                                                                      skyui.defines.Material.DRAGONPLATE,     "$Dragonplate"],
      [["ArmorMaterialDragonscale"],                                                                      skyui.defines.Material.DRAGONSCALE,     "$Dragonscale"],
      [["ArmorMaterialDwarven","WeapMaterialDwarven"],                                                    skyui.defines.Material.DWARVEN,         "$Dwarven"],
      [["ArmorMaterialEbony","WeapMaterialEbony"],                                                        skyui.defines.Material.EBONY,           "$Ebony"],
      [["ArmorMaterialElven","WeapMaterialElven"],                                                        skyui.defines.Material.ELVEN,           "$Elven"],
      [["ArmorMaterialElvenGilded"],                                                                      skyui.defines.Material.ELVENGILDED,     "$Elven Gilded"],
      [["ArmorMaterialGlass","WeapMaterialGlass"],                                                        skyui.defines.Material.GLASS,           "$Glass"],
      [["ArmorMaterialHide"],                                                                             skyui.defines.Material.HIDE,            "$Hide"],
      [["ArmorMaterialImperialHeavy","ArmorMaterialImperialLight","WeapMaterialImperial"],                skyui.defines.Material.IMPERIAL,        "$Imperial"],
      [["ArmorMaterialImperialStudded"],                                                                  skyui.defines.Material.IMPERIALSTUDDED, "$Studded"],
      [["ArmorMaterialIron","WeapMaterialIron"],                                                          skyui.defines.Material.IRON,            "$Iron"],
      [["ArmorMaterialIronBanded"],                                                                       skyui.defines.Material.IRONBANDED,      "$Iron Banded"],
      [["DLC1ArmorMaterialVampire"],                                                                      skyui.defines.Material.VAMPIRE,         "$Vampire"],
      [["ArmorMaterialLeather"],                                                                          skyui.defines.Material.LEATHER,         "$Leather"],
      [["ArmorMaterialOrcish","WeapMaterialOrcish"],                                                      skyui.defines.Material.ORCISH,          "$Orcish"],
      [["ArmorMaterialScaled"],                                                                           skyui.defines.Material.SCALED,          "$Scaled"],
      [["ArmorMaterialSteel","WeapMaterialSteel"],                                                        skyui.defines.Material.STEEL,           "$Steel"],
      [["ArmorMaterialSteelPlate"],                                                                       skyui.defines.Material.STEELPLATE,      "$Steel Plate"],
      [["ArmorMaterialStormcloak"],                                                                       skyui.defines.Material.STORMCLOAK,      "$Stormcloak"],
      [["ArmorMaterialStudded"],                                                                          skyui.defines.Material.STUDDED,         "$Studded"],
      [["DLC1ArmorMaterialDawnguard"],                                                                    skyui.defines.Material.DAWNGUARD,       "$Dawnguard"],
      [["DLC1ArmorMaterialFalmerHardened","DLC1ArmorMaterialFalmerHeavy"],                               skyui.defines.Material.FALMERHARDENED,  "$Falmer Hardened"],
      [["DLC1ArmorMaterialHunter"],                                                                       skyui.defines.Material.HUNTER,          "$Hunter"],
      [["DLC1LD_CraftingMaterialAetherium"],                                                             skyui.defines.Material.AETHERIUM,       "$Aetherium"],
      [["DLC1WeapMaterialDragonbone"],                                                                    skyui.defines.Material.DRAGONBONE,      "$Dragonbone"],
      [["DLC2ArmorMaterialBonemoldHeavy","DLC2ArmorMaterialBonemoldLight"],                              skyui.defines.Material.BONEMOLD,        "$Bonemold"],
      [["DLC2ArmorMaterialChitinHeavy","DLC2ArmorMaterialChitinLight"],                                  skyui.defines.Material.CHITIN,          "$Chitin"],
      [["DLC2ArmorMaterialMoragTong"],                                                                    skyui.defines.Material.MORAGTONG,       "$Morag Tong"],
      [["DLC2ArmorMaterialNordicHeavy","DLC2ArmorMaterialNordicLight","DLC2WeaponMaterialNordic"],       skyui.defines.Material.NORDIC,          "$Nordic"],
      [["DLC2ArmorMaterialStalhrimHeavy","DLC2ArmorMaterialStalhrimLight","DLC2WeaponMaterialStalhrim"],  skyui.defines.Material.STALHRIM,        "$Stalhrim"],
      [["WeapMaterialDraugr"],                                                                            skyui.defines.Material.DRAUGR,          "$Draugr"],
      [["WeapMaterialDraugrHoned"],                                                                       skyui.defines.Material.DRAUGRHONED,     "$Draugr Honed"],
      [["WeapMaterialFalmer"],                                                                            skyui.defines.Material.FALMER,          "$Falmer"],
      [["WeapMaterialFalmerHoned"],                                                                       skyui.defines.Material.FALMERHONED,     "$Falmer Honed"],
      [["WeapMaterialSilver"],                                                                            skyui.defines.Material.SILVER,          "$Silver"],
      [["WeapMaterialWood"],                                                                              skyui.defines.Material.WOOD,            "$Wood"]
   ];

   function InventoryDataSetter()
   {
      super();
   }

   // Rounds a value to 2 decimal places, returns null if value <= 0.
   function positiveRound(a_value)
   {
      return a_value <= 0 ? null : Math.round(a_value * 100) / 100;
   }

   function processEntry(a_entryObject, a_itemInfo)
   {
      a_entryObject.baseId         = a_entryObject.formId & 0xFFFFFF;
      a_entryObject.type           = a_itemInfo.type;
      a_entryObject.isEquipped     = a_entryObject.equipState > 0;
      a_entryObject.isStolen       = a_itemInfo.stolen == true;
      a_entryObject.infoValue      = positiveRound(a_itemInfo.value);
      a_entryObject.infoWeight     = positiveRound(a_itemInfo.weight);
      a_entryObject.infoValueWeight = (a_itemInfo.weight > 0 && a_itemInfo.value > 0)
         ? Math.round(a_itemInfo.value / a_itemInfo.weight) : null;

      switch(a_entryObject.formType)
      {
         case skyui.defines.Form.TYPE_SCROLLITEM:
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Scroll");
            a_entryObject.duration       = positiveRound(a_entryObject.duration);
            a_entryObject.magnitude      = positiveRound(a_entryObject.magnitude);
            break;
         case skyui.defines.Form.TYPE_ARMOR:
            a_entryObject.isEnchanted = a_itemInfo.effects != "";
            a_entryObject.infoArmor   = positiveRound(a_itemInfo.armor);
            this.processArmorClass(a_entryObject);
            this.processArmorPartMask(a_entryObject);
            this.processMaterialKeywords(a_entryObject);
            this.processArmorOther(a_entryObject);
            this.processArmorBaseId(a_entryObject);
            break;
         case skyui.defines.Form.TYPE_BOOK:
            this.processBookType(a_entryObject);
            break;
         case skyui.defines.Form.TYPE_INGREDIENT:
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Ingredient");
            break;
         case skyui.defines.Form.TYPE_LIGHT:
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Torch");
            break;
         case skyui.defines.Form.TYPE_MISC:
            this.processMiscType(a_entryObject);
            this.processMiscBaseId(a_entryObject);
            break;
         case skyui.defines.Form.TYPE_WEAPON:
            a_entryObject.isEnchanted = a_itemInfo.effects != "";
            a_entryObject.isPoisoned  = a_itemInfo.poisoned == true;
            a_entryObject.infoDamage  = positiveRound(a_itemInfo.damage);
            this.processWeaponType(a_entryObject);
            this.processMaterialKeywords(a_entryObject);
            this.processWeaponBaseId(a_entryObject);
            break;
         case skyui.defines.Form.TYPE_AMMO:
            a_entryObject.isEnchanted = a_itemInfo.effects != "";
            a_entryObject.infoDamage  = positiveRound(a_itemInfo.damage);
            this.processAmmoType(a_entryObject);
            this.processMaterialKeywords(a_entryObject);
            this.processAmmoBaseId(a_entryObject);
            break;
         case skyui.defines.Form.TYPE_KEY:
            this.processKeyType(a_entryObject);
            break;
         case skyui.defines.Form.TYPE_POTION:
            a_entryObject.duration  = positiveRound(a_entryObject.duration);
            a_entryObject.magnitude = positiveRound(a_entryObject.magnitude);
            this.processPotionType(a_entryObject);
            break;
         case skyui.defines.Form.TYPE_SOULGEM:
            this.processSoulGemType(a_entryObject);
            this.processSoulGemStatus(a_entryObject);
            this.processSoulGemBaseId(a_entryObject);
         default:
            return;
      }
   }

   function processArmorClass(a_entryObject)
   {
      if(a_entryObject.weightClass == skyui.defines.Armor.WEIGHT_NONE)
      {
         a_entryObject.weightClass = null;
      }
      a_entryObject.weightClassDisplay = skyui.util.Translator.translate("$Other");
      switch(a_entryObject.weightClass)
      {
         case skyui.defines.Armor.WEIGHT_LIGHT:
            a_entryObject.weightClassDisplay = skyui.util.Translator.translate("$Light");
            return;
         case skyui.defines.Armor.WEIGHT_HEAVY:
            a_entryObject.weightClassDisplay = skyui.util.Translator.translate("$Heavy");
            return;
         default:
            if(a_entryObject.keywords == undefined)
            {
               return;
            }
            if(a_entryObject.keywords.VendorItemClothing != undefined)
            {
               a_entryObject.weightClass        = skyui.defines.Armor.WEIGHT_CLOTHING;
               a_entryObject.weightClassDisplay = skyui.util.Translator.translate("$Clothing");
               return;
            }
            if(a_entryObject.keywords.VendorItemJewelry != undefined)
            {
               a_entryObject.weightClass        = skyui.defines.Armor.WEIGHT_JEWELRY;
               a_entryObject.weightClassDisplay = skyui.util.Translator.translate("$Jewelry");
               return;
            }
            return;
      }
   }

   function processMaterialKeywords(a_entryObject)
   {
      a_entryObject.material        = null;
      a_entryObject.materialDisplay = skyui.util.Translator.translate("$Other");

      var kw = a_entryObject.keywords;
      if(kw == undefined) return;

      var table = InventoryDataSetter.MATERIAL_KEYWORD_TABLE;
      for(var i = 0; i < table.length; i++)
      {
         var entry   = table[i];
         var keys    = entry[0];
         var matched = false;
         for(var j = 0; j < keys.length; j++)
         {
            if(kw[keys[j]] != undefined)
            {
               matched = true;
               break;
            }
         }
         if(matched)
         {
            a_entryObject.material        = entry[1];
            a_entryObject.materialDisplay = skyui.util.Translator.translate(entry[2]);
            // Special case: Stalhrim can be overridden to Deathbrand
            if(entry[1] == skyui.defines.Material.STALHRIM && kw.DLC2dunHaknirArmor != undefined)
            {
               a_entryObject.material        = skyui.defines.Material.DEATHBRAND;
               a_entryObject.materialDisplay = skyui.util.Translator.translate("$Deathbrand");
            }
            return;
         }
      }
   }

   function processWeaponType(a_entryObject)
   {
      a_entryObject.subType        = null;
      a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Weapon");
      switch(a_entryObject.weaponType)
      {
         case skyui.defines.Weapon.ANIM_HANDTOHANDMELEE:
         case skyui.defines.Weapon.ANIM_H2H:
            a_entryObject.subType        = skyui.defines.Weapon.TYPE_MELEE;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Melee");
            break;
         case skyui.defines.Weapon.ANIM_ONEHANDSWORD:
         case skyui.defines.Weapon.ANIM_1HS:
            a_entryObject.subType        = skyui.defines.Weapon.TYPE_SWORD;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Sword");
            break;
         case skyui.defines.Weapon.ANIM_ONEHANDDAGGER:
         case skyui.defines.Weapon.ANIM_1HD:
            a_entryObject.subType        = skyui.defines.Weapon.TYPE_DAGGER;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Dagger");
            break;
         case skyui.defines.Weapon.ANIM_ONEHANDAXE:
         case skyui.defines.Weapon.ANIM_1HA:
            a_entryObject.subType        = skyui.defines.Weapon.TYPE_WARAXE;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$War Axe");
            break;
         case skyui.defines.Weapon.ANIM_ONEHANDMACE:
         case skyui.defines.Weapon.ANIM_1HM:
            a_entryObject.subType        = skyui.defines.Weapon.TYPE_MACE;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Mace");
            break;
         case skyui.defines.Weapon.ANIM_TWOHANDSWORD:
         case skyui.defines.Weapon.ANIM_2HS:
            a_entryObject.subType        = skyui.defines.Weapon.TYPE_GREATSWORD;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Greatsword");
            break;
         case skyui.defines.Weapon.ANIM_TWOHANDAXE:
         case skyui.defines.Weapon.ANIM_2HA:
            a_entryObject.subType        = skyui.defines.Weapon.TYPE_BATTLEAXE;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Battleaxe");
            if(a_entryObject.keywords != undefined && a_entryObject.keywords.WeapTypeWarhammer != undefined)
            {
               a_entryObject.subType        = skyui.defines.Weapon.TYPE_WARHAMMER;
               a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Warhammer");
            }
            break;
         case skyui.defines.Weapon.ANIM_BOW:
         case skyui.defines.Weapon.ANIM_BOW2:
            a_entryObject.subType        = skyui.defines.Weapon.TYPE_BOW;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Bow");
            break;
         case skyui.defines.Weapon.ANIM_STAFF:
         case skyui.defines.Weapon.ANIM_STAFF2:
            a_entryObject.subType        = skyui.defines.Weapon.TYPE_STAFF;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Staff");
            break;
         case skyui.defines.Weapon.ANIM_CROSSBOW:
         case skyui.defines.Weapon.ANIM_CBOW:
            a_entryObject.subType        = skyui.defines.Weapon.TYPE_CROSSBOW;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Crossbow");
         default:
            return;
      }
   }

   function processWeaponBaseId(a_entryObject)
   {
      switch(a_entryObject.baseId)
      {
         case skyui.defines.Form.BASEID_WEAPPICKAXE:
         case skyui.defines.Form.BASEID_SSDROCKSPLINTERPICKAXE:
         case skyui.defines.Form.BASEID_DUNVOLUNRUUDPICKAXE:
            a_entryObject.subType        = skyui.defines.Weapon.TYPE_PICKAXE;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Pickaxe");
            break;
         case skyui.defines.Form.BASEID_AXE01:
         case skyui.defines.Form.BASEID_DUNHALTEDSTREAMPOACHERSAXE:
            a_entryObject.subType        = skyui.defines.Weapon.TYPE_WOODAXE;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Wood Axe");
         default:
            return;
      }
   }

   function processArmorPartMask(a_entryObject)
   {
      if(a_entryObject.partMask == undefined)
      {
         return undefined;
      }
      var _loc2_ = 0;
      while(_loc2_ < skyui.defines.Armor.PARTMASK_PRECEDENCE.length)
      {
         if(a_entryObject.partMask & skyui.defines.Armor.PARTMASK_PRECEDENCE[_loc2_])
         {
            a_entryObject.mainPartMask = skyui.defines.Armor.PARTMASK_PRECEDENCE[_loc2_];
            break;
         }
         _loc2_ = _loc2_ + 1;
      }
      if(a_entryObject.mainPartMask == undefined)
      {
         return undefined;
      }
      switch(a_entryObject.mainPartMask)
      {
         case skyui.defines.Armor.PARTMASK_HEAD:
            a_entryObject.subType        = skyui.defines.Armor.EQUIP_HEAD;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Head");
            return;
         case skyui.defines.Armor.PARTMASK_HAIR:
            a_entryObject.subType        = skyui.defines.Armor.EQUIP_HAIR;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Head");
            return;
         case skyui.defines.Armor.PARTMASK_LONGHAIR:
            a_entryObject.subType        = skyui.defines.Armor.EQUIP_LONGHAIR;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Head");
            return;
         case skyui.defines.Armor.PARTMASK_BODY:
            a_entryObject.subType        = skyui.defines.Armor.EQUIP_BODY;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Body");
            return;
         case skyui.defines.Armor.PARTMASK_HANDS:
            a_entryObject.subType        = skyui.defines.Armor.EQUIP_HANDS;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Hands");
            return;
         case skyui.defines.Armor.PARTMASK_FOREARMS:
            a_entryObject.subType        = skyui.defines.Armor.EQUIP_FOREARMS;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Forearms");
            return;
         case skyui.defines.Armor.PARTMASK_AMULET:
            a_entryObject.subType        = skyui.defines.Armor.EQUIP_AMULET;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Amulet");
            return;
         case skyui.defines.Armor.PARTMASK_RING:
            a_entryObject.subType        = skyui.defines.Armor.EQUIP_RING;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Ring");
            return;
         case skyui.defines.Armor.PARTMASK_FEET:
            a_entryObject.subType        = skyui.defines.Armor.EQUIP_FEET;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Feet");
            return;
         case skyui.defines.Armor.PARTMASK_CALVES:
            a_entryObject.subType        = skyui.defines.Armor.EQUIP_CALVES;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Calves");
            return;
         case skyui.defines.Armor.PARTMASK_SHIELD:
            a_entryObject.subType        = skyui.defines.Armor.EQUIP_SHIELD;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Shield");
            return;
         case skyui.defines.Armor.PARTMASK_CIRCLET:
            a_entryObject.subType        = skyui.defines.Armor.EQUIP_CIRCLET;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Circlet");
            return;
         case skyui.defines.Armor.PARTMASK_EARS:
            a_entryObject.subType        = skyui.defines.Armor.EQUIP_EARS;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Ears");
            return;
         case skyui.defines.Armor.PARTMASK_TAIL:
            a_entryObject.subType        = skyui.defines.Armor.EQUIP_TAIL;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Tail");
            return;
         default:
            a_entryObject.subType = a_entryObject.mainPartMask;
            return;
      }
   }

   function processArmorOther(a_entryObject)
   {
      if(a_entryObject.weightClass != null)
      {
         return undefined;
      }
      switch(a_entryObject.mainPartMask)
      {
         case skyui.defines.Armor.PARTMASK_HEAD:
         case skyui.defines.Armor.PARTMASK_HAIR:
         case skyui.defines.Armor.PARTMASK_LONGHAIR:
         case skyui.defines.Armor.PARTMASK_BODY:
         case skyui.defines.Armor.PARTMASK_HANDS:
         case skyui.defines.Armor.PARTMASK_FOREARMS:
         case skyui.defines.Armor.PARTMASK_FEET:
         case skyui.defines.Armor.PARTMASK_CALVES:
         case skyui.defines.Armor.PARTMASK_SHIELD:
         case skyui.defines.Armor.PARTMASK_TAIL:
            a_entryObject.weightClass        = skyui.defines.Armor.WEIGHT_CLOTHING;
            a_entryObject.weightClassDisplay = skyui.util.Translator.translate("$Clothing");
            break;
         case skyui.defines.Armor.PARTMASK_AMULET:
         case skyui.defines.Armor.PARTMASK_RING:
         case skyui.defines.Armor.PARTMASK_CIRCLET:
         case skyui.defines.Armor.PARTMASK_EARS:
            a_entryObject.weightClass        = skyui.defines.Armor.WEIGHT_JEWELRY;
            a_entryObject.weightClassDisplay = skyui.util.Translator.translate("$Jewelry");
         default:
            return;
      }
   }

   function processArmorBaseId(a_entryObject)
   {
      switch(a_entryObject.baseId)
      {
         case skyui.defines.Form.BASEID_CLOTHESWEDDINGWREATH:
            a_entryObject.weightClass        = skyui.defines.Armor.WEIGHT_JEWELRY;
            a_entryObject.weightClassDisplay = skyui.util.Translator.translate("$Jewelry");
            break;
         case skyui.defines.Form.BASEID_DLC1CLOTHESVAMPIRELORDARMOR:
            a_entryObject.subType        = skyui.defines.Armor.EQUIP_BODY;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Body");
         default:
            return;
      }
   }

   function processBookType(a_entryObject)
   {
      a_entryObject.subType        = skyui.defines.Item.OTHER;
      a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Book");
      a_entryObject.isRead         = (a_entryObject.flags & skyui.defines.Item.BOOKFLAG_READ) != 0;

      if(a_entryObject.bookType == skyui.defines.Item.BOOKTYPE_NOTE)
      {
         a_entryObject.subType        = skyui.defines.Item.BOOK_NOTE;
         a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Note");
      }
      if(a_entryObject.keywords == undefined)
      {
         return undefined;
      }
      if(a_entryObject.keywords.VendorItemRecipe != undefined)
      {
         a_entryObject.subType        = skyui.defines.Item.BOOK_RECIPE;
         a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Recipe");
      }
      else if(a_entryObject.keywords.VendorItemSpellTome != undefined)
      {
         a_entryObject.subType        = skyui.defines.Item.BOOK_SPELLTOME;
         a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Spell Tome");
      }
   }

   function processAmmoType(a_entryObject)
   {
      if((a_entryObject.flags & skyui.defines.Weapon.AMMOFLAG_NONBOLT) != 0)
      {
         a_entryObject.subType        = skyui.defines.Weapon.AMMO_ARROW;
         a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Arrow");
      }
      else
      {
         a_entryObject.subType        = skyui.defines.Weapon.AMMO_BOLT;
         a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Bolt");
      }
   }

   function processAmmoBaseId(a_entryObject)
   {
      switch(a_entryObject.baseId)
      {
         case skyui.defines.Form.BASEID_DAEDRICARROW:
            a_entryObject.material        = skyui.defines.Material.DAEDRIC;
            a_entryObject.materialDisplay = skyui.util.Translator.translate("$Daedric");
            break;
         case skyui.defines.Form.BASEID_EBONYARROW:
            a_entryObject.material        = skyui.defines.Material.EBONY;
            a_entryObject.materialDisplay = skyui.util.Translator.translate("$Ebony");
            break;
         case skyui.defines.Form.BASEID_GLASSARROW:
            a_entryObject.material        = skyui.defines.Material.GLASS;
            a_entryObject.materialDisplay = skyui.util.Translator.translate("$Glass");
            break;
         case skyui.defines.Form.BASEID_ELVENARROW:
         case skyui.defines.Form.BASEID_DLC1ELVENARROWBLESSED:
         case skyui.defines.Form.BASEID_DLC1ELVENARROWBLOOD:
            a_entryObject.material        = skyui.defines.Material.ELVEN;
            a_entryObject.materialDisplay = skyui.util.Translator.translate("$Elven");
            break;
         case skyui.defines.Form.BASEID_DWARVENARROW:
         case skyui.defines.Form.BASEID_DWARVENSPHEREARROW:
         case skyui.defines.Form.BASEID_DWARVENSPHEREBOLT01:
         case skyui.defines.Form.BASEID_DWARVENSPHEREBOLT02:
         case skyui.defines.Form.BASEID_DLC2DWARVENBALLISTABOLT:
            a_entryObject.material        = skyui.defines.Material.DWARVEN;
            a_entryObject.materialDisplay = skyui.util.Translator.translate("$Dwarven");
            break;
         case skyui.defines.Form.BASEID_ORCISHARROW:
            a_entryObject.material        = skyui.defines.Material.ORCISH;
            a_entryObject.materialDisplay = skyui.util.Translator.translate("$Orcish");
            break;
         case skyui.defines.Form.BASEID_NORDHEROARROW:
            a_entryObject.material        = skyui.defines.Material.NORDIC;
            a_entryObject.materialDisplay = skyui.util.Translator.translate("$Nordic");
            break;
         case skyui.defines.Form.BASEID_DRAUGRARROW:
            a_entryObject.material        = skyui.defines.Material.DRAUGR;
            a_entryObject.materialDisplay = skyui.util.Translator.translate("$Draugr");
            break;
         case skyui.defines.Form.BASEID_FALMERARROW:
            a_entryObject.material        = skyui.defines.Material.FALMER;
            a_entryObject.materialDisplay = skyui.util.Translator.translate("$Falmer");
            break;
         case skyui.defines.Form.BASEID_STEELARROW:
         case skyui.defines.Form.BASEID_MQ101STEELARROW:
            a_entryObject.material        = skyui.defines.Material.STEEL;
            a_entryObject.materialDisplay = skyui.util.Translator.translate("$Steel");
            break;
         case skyui.defines.Form.BASEID_IRONARROW:
         case skyui.defines.Form.BASEID_CWARROW:
         case skyui.defines.Form.BASEID_CWARROWSHORT:
         case skyui.defines.Form.BASEID_TRAPDART:
         case skyui.defines.Form.BASEID_DUNARCHERPRATICEARROW:
         case skyui.defines.Form.BASEID_DUNGEIRMUNDSIGDISARROWSILLUSION:
         case skyui.defines.Form.BASEID_FOLLOWERIRONARROW:
         case skyui.defines.Form.BASEID_TESTDLC1BOLT:
            a_entryObject.material        = skyui.defines.Material.IRON;
            a_entryObject.materialDisplay = skyui.util.Translator.translate("$Iron");
            break;
         case skyui.defines.Form.BASEID_FORSWORNARROW:
            a_entryObject.material        = skyui.defines.Material.HIDE;
            a_entryObject.materialDisplay = skyui.util.Translator.translate("$Forsworn");
            break;
         case skyui.defines.Form.BASEID_DLC2RIEKLINGSPEARTHROWN:
            a_entryObject.material        = skyui.defines.Material.WOOD;
            a_entryObject.materialDisplay = skyui.util.Translator.translate("$Wood");
            a_entryObject.subTypeDisplay  = skyui.util.Translator.translate("$Spear");
         default:
            return;
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
      a_entryObject.subType        = skyui.defines.Item.POTION_POTION;
      a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Potion");

      if((a_entryObject.flags & skyui.defines.Item.ALCHFLAG_FOOD) != 0)
      {
         a_entryObject.subType        = skyui.defines.Item.POTION_FOOD;
         a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Food");
         if(a_entryObject.useSound.formId != undefined && a_entryObject.useSound.formId == skyui.defines.Form.FORMID_ITMPotionUse)
         {
            a_entryObject.subType        = skyui.defines.Item.POTION_DRINK;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Drink");
         }
      }
      else if((a_entryObject.flags & skyui.defines.Item.ALCHFLAG_POISON) != 0)
      {
         a_entryObject.subType        = skyui.defines.Item.POTION_POISON;
         a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Poison");
      }
      else
      {
         switch(a_entryObject.actorValue)
         {
            case skyui.defines.Actor.AV_HEALTH:
               a_entryObject.subType        = skyui.defines.Item.POTION_HEALTH;
               a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Health");
               break;
            case skyui.defines.Actor.AV_MAGICKA:
               a_entryObject.subType        = skyui.defines.Item.POTION_MAGICKA;
               a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Magicka");
               break;
            case skyui.defines.Actor.AV_STAMINA:
               a_entryObject.subType        = skyui.defines.Item.POTION_STAMINA;
               a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Stamina");
               break;
            case skyui.defines.Actor.AV_HEALRATE:
               a_entryObject.subType        = skyui.defines.Item.POTION_HEALRATE;
               a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Health");
               break;
            case skyui.defines.Actor.AV_MAGICKARATE:
               a_entryObject.subType        = skyui.defines.Item.POTION_MAGICKARATE;
               a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Magicka");
               break;
            case skyui.defines.Actor.AV_STAMINARATE:
               a_entryObject.subType        = skyui.defines.Item.POTION_STAMINARATE;
               a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Stamina");
               break;
            case skyui.defines.Actor.AV_HEALRATEMULT:
               a_entryObject.subType        = skyui.defines.Item.POTION_HEALRATEMULT;
               a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Health");
               break;
            case skyui.defines.Actor.AV_MAGICKARATEMULT:
               a_entryObject.subType        = skyui.defines.Item.POTION_MAGICKARATEMULT;
               a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Magicka");
               break;
            case skyui.defines.Actor.AV_STAMINARATEMULT:
               a_entryObject.subType        = skyui.defines.Item.POTION_STAMINARATEMULT;
               a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Stamina");
               break;
            case skyui.defines.Actor.AV_FIRERESIST:
               a_entryObject.subType = skyui.defines.Item.POTION_FIRERESIST;
               break;
            case skyui.defines.Actor.AV_ELECTRICRESIST:
               a_entryObject.subType = skyui.defines.Item.POTION_ELECTRICRESIST;
               break;
            case skyui.defines.Actor.AV_FROSTRESIST:
               a_entryObject.subType = skyui.defines.Item.POTION_FROSTRESIST;
            default:
               return;
         }
      }
   }

   function processSoulGemType(a_entryObject)
   {
      a_entryObject.subType        = skyui.defines.Item.OTHER;
      a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Soul Gem");
      if(a_entryObject.gemSize != undefined && a_entryObject.gemSize != skyui.defines.Item.SOULGEM_NONE)
      {
         a_entryObject.subType = a_entryObject.gemSize;
      }
   }

   function processSoulGemStatus(a_entryObject)
   {
      if(a_entryObject.gemSize == undefined || a_entryObject.soulSize == undefined || a_entryObject.soulSize == skyui.defines.Item.SOULGEM_NONE)
      {
         a_entryObject.status = skyui.defines.Item.SOULGEMSTATUS_EMPTY;
      }
      else if(a_entryObject.soulSize >= a_entryObject.gemSize)
      {
         a_entryObject.status = skyui.defines.Item.SOULGEMSTATUS_FULL;
      }
      else
      {
         a_entryObject.status = skyui.defines.Item.SOULGEMSTATUS_PARTIAL;
      }
   }

   function processSoulGemBaseId(a_entryObject)
   {
      switch(a_entryObject.baseId)
      {
         case skyui.defines.Form.BASEID_DA01SOULGEMBLACKSTAR:
         case skyui.defines.Form.BASEID_DA01SOULGEMAZURASSTAR:
            a_entryObject.subType = skyui.defines.Item.SOULGEM_AZURA;
         default:
            return;
      }
   }

   function processMiscType(a_entryObject)
   {
      a_entryObject.subType        = skyui.defines.Item.OTHER;
      a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Misc");

      var kw = a_entryObject.keywords;
      if(kw == undefined) return undefined;

      if(kw.BYOHAdoptionClothesKeyword != undefined)
      {
         a_entryObject.subType        = skyui.defines.Item.MISC_CHILDRENSCLOTHES;
         a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Clothing");
      }
      else if(kw.BYOHAdoptionToyKeyword != undefined)
      {
         a_entryObject.subType        = skyui.defines.Item.MISC_TOY;
         a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Toy");
      }
      else if(kw.BYOHHouseCraftingCategoryWeaponRacks != undefined
           || kw.BYOHHouseCraftingCategoryShelf != undefined
           || kw.BYOHHouseCraftingCategoryFurniture != undefined
           || kw.BYOHHouseCraftingCategoryExterior != undefined
           || kw.BYOHHouseCraftingCategoryContainers != undefined
           || kw.BYOHHouseCraftingCategoryBuilding != undefined
           || kw.BYOHHouseCraftingCategorySmithing != undefined)
      {
         a_entryObject.subType        = skyui.defines.Item.MISC_HOUSEPART;
         a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$House Part");
      }
      else if(kw.VendorItemDaedricArtifact != undefined)
      {
         a_entryObject.subType        = skyui.defines.Item.MISC_ARTIFACT;
         a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Artifact");
      }
      else if(kw.VendorItemGem != undefined)
      {
         a_entryObject.subType        = skyui.defines.Item.MISC_GEM;
         a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Gem");
      }
      else if(kw.VendorItemAnimalHide != undefined)
      {
         a_entryObject.subType        = skyui.defines.Item.MISC_HIDE;
         a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Hide");
      }
      else if(kw.VendorItemTool != undefined)
      {
         a_entryObject.subType        = skyui.defines.Item.MISC_TOOL;
         a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Tool");
      }
      else if(kw.VendorItemAnimalPart != undefined)
      {
         a_entryObject.subType        = skyui.defines.Item.MISC_REMAINS;
         a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Remains");
      }
      else if(kw.VendorItemOreIngot != undefined)
      {
         a_entryObject.subType        = skyui.defines.Item.MISC_INGOT;
         a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Ingot");
      }
      else if(kw.VendorItemClutter != undefined)
      {
         a_entryObject.subType        = skyui.defines.Item.MISC_CLUTTER;
         a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Clutter");
      }
      else if(kw.VendorItemFirewood != undefined)
      {
         a_entryObject.subType        = skyui.defines.Item.MISC_FIREWOOD;
         a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Firewood");
      }
   }

   function processMiscBaseId(a_entryObject)
   {
      switch(a_entryObject.baseId)
      {
         case skyui.defines.Form.BASEID_GEMAMETHYSTFLAWLESS:
            a_entryObject.subType        = skyui.defines.Item.MISC_GEM;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Gem");
            break;
         case skyui.defines.Form.BASEID_RUBYDRAGONCLAW:
         case skyui.defines.Form.BASEID_IVORYDRAGONCLAW:
         case skyui.defines.Form.BASEID_GLASSCLAW:
         case skyui.defines.Form.BASEID_EBONYCLAW:
         case skyui.defines.Form.BASEID_EMERALDDRAGONCLAW:
         case skyui.defines.Form.BASEID_DIAMONDCLAW:
         case skyui.defines.Form.BASEID_IRONCLAW:
         case skyui.defines.Form.BASEID_CORALDRAGONCLAW:
         case skyui.defines.Form.BASEID_E3GOLDENCLAW:
         case skyui.defines.Form.BASEID_SAPPHIREDRAGONCLAW:
         case skyui.defines.Form.BASEID_MS13GOLDENCLAW:
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Claw");
            a_entryObject.subType        = skyui.defines.Item.MISC_DRAGONCLAW;
            break;
         case skyui.defines.Form.BASEID_LOCKPICK:
            a_entryObject.subType        = skyui.defines.Item.MISC_LOCKPICK;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Lockpick");
            break;
         case skyui.defines.Form.BASEID_GOLD001:
            a_entryObject.subType        = skyui.defines.Item.MISC_GOLD;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Gold");
            break;
         case skyui.defines.Form.BASEID_LEATHER01:
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Leather");
            a_entryObject.subType        = skyui.defines.Item.MISC_LEATHER;
            break;
         case skyui.defines.Form.BASEID_LEATHERSTRIPS:
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Strips");
            a_entryObject.subType        = skyui.defines.Item.MISC_LEATHERSTRIPS;
         default:
            return;
      }
   }
}
