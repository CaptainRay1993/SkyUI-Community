class CraftingDataSetter implements skyui.components.list.IListProcessor
{
   function CraftingDataSetter()
   {
      super();
   }
   function processList(a_list)
   {
      var _loc4_ = a_list.entryList;
      var _loc3_ = 0;
      var _loc2_;
      while(_loc3_ < _loc4_.length)
      {
         _loc2_ = _loc4_[_loc3_];
         if(!_loc2_.skyui_itemDataProcessed)
         {
            _loc2_.skyui_itemDataProcessed = true;
            this.fixSKSEExtendedObject(_loc2_);
            this.processEntry(_loc2_);
         }
         _loc3_ = _loc3_ + 1;
      }
   }
   function processEntry(a_entryObject)
   {
      a_entryObject.baseId = a_entryObject.formId & 0xFFFFFF;
      a_entryObject.isEquipped = a_entryObject.equipState > 0;
      a_entryObject.infoValue = a_entryObject.value <= 0 ? null : Math.round(a_entryObject.value * 100) / 100;
      a_entryObject.infoWeight = a_entryObject.weight <= 0 ? null : Math.round(a_entryObject.weight * 100) / 100;
      a_entryObject.infoValueWeight = !(a_entryObject.weight > 0 && a_entryObject.value > 0) ? null : Math.round(a_entryObject.value / a_entryObject.weight * 100) / 100;
      switch(a_entryObject.formType)
      {
         case skyui.defines.Form.TYPE_SCROLLITEM:
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Scroll");
            a_entryObject.duration = a_entryObject.duration <= 0 ? null : Math.round(a_entryObject.duration * 100) / 100;
            a_entryObject.magnitude = a_entryObject.magnitude <= 0 ? null : Math.round(a_entryObject.magnitude * 100) / 100;
            break;
         case skyui.defines.Form.TYPE_ARMOR:
            a_entryObject.infoArmor = a_entryObject.armor <= 0 ? null : Math.round(a_entryObject.armor * 100) / 100;
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
            a_entryObject.infoDamage = a_entryObject.damage <= 0 ? null : Math.round(a_entryObject.damage * 100) / 100;
            this.processWeaponType(a_entryObject);
            this.processMaterialKeywords(a_entryObject);
            this.processWeaponBaseId(a_entryObject);
            break;
         case skyui.defines.Form.TYPE_AMMO:
            a_entryObject.infoDamage = a_entryObject.damage <= 0 ? null : Math.round(a_entryObject.damage * 100) / 100;
            this.processAmmoType(a_entryObject);
            this.processMaterialKeywords(a_entryObject);
            this.processAmmoBaseId(a_entryObject);
            break;
         case skyui.defines.Form.TYPE_KEY:
            this.processKeyType(a_entryObject);
            break;
         case skyui.defines.Form.TYPE_POTION:
            a_entryObject.duration = a_entryObject.duration <= 0 ? null : Math.round(a_entryObject.duration * 100) / 100;
            a_entryObject.magnitude = a_entryObject.magnitude <= 0 ? null : Math.round(a_entryObject.magnitude * 100) / 100;
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
               a_entryObject.weightClass = skyui.defines.Armor.WEIGHT_CLOTHING;
               a_entryObject.weightClassDisplay = skyui.util.Translator.translate("$Clothing");
               return;
            }
            if(a_entryObject.keywords.VendorItemJewelry != undefined)
            {
               a_entryObject.weightClass = skyui.defines.Armor.WEIGHT_JEWELRY;
               a_entryObject.weightClassDisplay = skyui.util.Translator.translate("$Jewelry");
               return;
            }
            return;
      }
   }
   function processMaterialKeywords(a_entryObject)
   {
      a_entryObject.material = null;
      a_entryObject.materialDisplay = skyui.util.Translator.translate("$Other");
      if(a_entryObject.keywords == undefined)
      {
         return undefined;
      }
      if(a_entryObject.keywords.ccBGSSSE001_FishingPoleKW != undefined)
      {
         a_entryObject.material = null;
         a_entryObject.materialDisplay = null;
      } 
      else if(a_entryObject.keywords.ArmorMaterialDaedric != undefined || a_entryObject.keywords.WeapMaterialDaedric != undefined || a_entryObject.keywords.ccBGSSSE025_ArmorMaterialDark != undefined || a_entryObject.keywords.ccBGSSSE025_WeapMaterialDark != undefined || a_entryObject.keywords.ccBGSSSE025_ArmorMaterialGolden != undefined || a_entryObject.keywords.ccBGSSSE025_WeapMaterialGolden != undefined)
      {
         a_entryObject.material = skyui.defines.Material.DAEDRIC;
         a_entryObject.materialDisplay = skyui.util.Translator.translate("$Daedric");
      }
      else if(a_entryObject.keywords.ArmorMaterialDragonplate != undefined || a_entryObject.keywords.ArmorMaterialDragonscale != undefined || a_entryObject.keywords.DLC1WeapMaterialDragonbone != undefined)
      {
         a_entryObject.material = skyui.defines.Material.DRAGON;
         a_entryObject.materialDisplay = skyui.util.Translator.translate("$Dragon");
      }
      else if(a_entryObject.keywords.ArmorMaterialDwarven != undefined || a_entryObject.keywords.WeapMaterialDwarven != undefined)
      {
         a_entryObject.material = skyui.defines.Material.DWARVEN;
         a_entryObject.materialDisplay = skyui.util.Translator.translate("$Dwarven");
      }
      else if(a_entryObject.keywords.ArmorMaterialEbony != undefined || a_entryObject.keywords.WeapMaterialEbony != undefined)
      {
         a_entryObject.material = skyui.defines.Material.EBONY;
         a_entryObject.materialDisplay = skyui.util.Translator.translate("$Ebony");
      }
      else if(a_entryObject.keywords.ArmorMaterialElven != undefined || a_entryObject.keywords.WeapMaterialElven != undefined || a_entryObject.keywords.ArmorMaterialElvenGilded != undefined)
      {
         a_entryObject.material = skyui.defines.Material.ELVEN;
         a_entryObject.materialDisplay = skyui.util.Translator.translate("$Elven");
      }
      else if(a_entryObject.keywords.ArmorMaterialGlass != undefined || a_entryObject.keywords.WeapMaterialGlass != undefined)
      {
         a_entryObject.material = skyui.defines.Material.GLASS;
         a_entryObject.materialDisplay = skyui.util.Translator.translate("$Glass");
      }
      else if(a_entryObject.keywords.ArmorMaterialHide != undefined || a_entryObject.keywords.ArmorMaterialScaled != undefined)
      {
         a_entryObject.material = skyui.defines.Material.HIDE;
         a_entryObject.materialDisplay = skyui.util.Translator.translate("$Hide");
      }
      else if(a_entryObject.keywords.ArmorMaterialStormcloak != undefined || a_entryObject.keywords.ArmorMaterialBearStormcloak != undefined)
      {
         a_entryObject.material = skyui.defines.Material.STORMCLOAK;
         a_entryObject.materialDisplay = skyui.util.Translator.translate("$Stormcloak");
      }
      else if(a_entryObject.keywords.ArmorMaterialForsworn != undefined)
      {
         a_entryObject.material = skyui.defines.Material.FORSWORN;
         a_entryObject.materialDisplay = skyui.util.Translator.translate("$Forsworn");
      }
      else if(a_entryObject.keywords.ArmorMaterialImperialHeavy != undefined || a_entryObject.keywords.ArmorMaterialImperialLight != undefined || a_entryObject.keywords.WeapMaterialImperial != undefined || a_entryObject.keywords.ArmorMaterialImperialStudded != undefined || a_entryObject.keywords.ArmorMaterialStudded != undefined)
      {
         a_entryObject.material = skyui.defines.Material.IMPERIAL;
         a_entryObject.materialDisplay = skyui.util.Translator.translate("$Imperial");
      }
      else if(a_entryObject.keywords.ArmorMaterialIron != undefined || a_entryObject.keywords.WeapMaterialIron != undefined || a_entryObject.keywords.ArmorMaterialIronBanded != undefined)
      {
         a_entryObject.material = skyui.defines.Material.IRON;
         a_entryObject.materialDisplay = skyui.util.Translator.translate("$Iron");
      }
      else if(a_entryObject.keywords.ArmorMaterialLeather != undefined)
      {
         a_entryObject.material = skyui.defines.Material.LEATHER;
         a_entryObject.materialDisplay = skyui.util.Translator.translate("$Leather");
      }
      else if(a_entryObject.keywords.ArmorMaterialOrcish != undefined || a_entryObject.keywords.WeapMaterialOrcish != undefined || a_entryObject.keywords.ccBGSSSE055_ArmorMaterialOrcishLight != undefined)
      {
         a_entryObject.material = skyui.defines.Material.ORCISH;
         a_entryObject.materialDisplay = skyui.util.Translator.translate("$Orcish");
      }
      else if(a_entryObject.keywords.ArmorMaterialSteel != undefined || a_entryObject.keywords.WeapMaterialSteel != undefined || a_entryObject.keywords.ArmorMaterialSteelPlate != undefined || a_entryObject.keywords.WeapMaterialDraugr != undefined || a_entryObject.keywords.WeapMaterialDraugrHoned != undefined)
      {
         a_entryObject.material = skyui.defines.Material.STEEL;
         a_entryObject.materialDisplay = skyui.util.Translator.translate("$Steel");
      }
      else if(a_entryObject.keywords.WeapMaterialSilver != undefined)
      {
         a_entryObject.material = skyui.defines.Material.SILVER;
         a_entryObject.materialDisplay = skyui.util.Translator.translate("$Silver");
      }
      else if(a_entryObject.keywords.ArmorMaterialFalmer != undefined || a_entryObject.keywords.DLC1ArmorMaterialFalmerHardened != undefined || a_entryObject.keywords.DLC1ArmorMaterielFalmerHeavy != undefined || a_entryObject.keywords.DLC1ArmorMaterielFalmerHeavyOriginal != undefined)
      {
         a_entryObject.material = skyui.defines.Material.FALMER;
         a_entryObject.materialDisplay = skyui.util.Translator.translate("$Falmer");
      }
      else if(a_entryObject.keywords.DLC1LD_CraftingMaterialAetherium != undefined)
      {
         a_entryObject.material = skyui.defines.Material.AETHERIUM;
         a_entryObject.materialDisplay = skyui.util.Translator.translate("$Aetherium");
      }
      else if(a_entryObject.keywords.DLC2ArmorMaterialBonemoldHeavy != undefined || a_entryObject.keywords.DLC2ArmorMaterialBonemoldLight != undefined)
      {
         a_entryObject.material = skyui.defines.Material.BONEMOLD;
         a_entryObject.materialDisplay = skyui.util.Translator.translate("$Bonemold");
      }
      else if(a_entryObject.keywords.DLC2ArmorMaterialChitinHeavy != undefined || a_entryObject.keywords.DLC2ArmorMaterialChitinLight != undefined)
      {
         a_entryObject.material = skyui.defines.Material.CHITIN;
         a_entryObject.materialDisplay = skyui.util.Translator.translate("$Chitin");
      }
      else if(a_entryObject.keywords.DLC2ArmorMaterialNordicHeavy != undefined || a_entryObject.keywords.DLC2ArmorMaterialNordicLight != undefined || a_entryObject.keywords.DLC2WeaponMaterialNordic != undefined || a_entryObject.keywords.ccEDHSSE001_NordicJewelryKeyword != undefined)
      {
         a_entryObject.material = skyui.defines.Material.NORDIC;
         a_entryObject.materialDisplay = skyui.util.Translator.translate("$Nordic");
      }
      else if(a_entryObject.keywords.DLC2ArmorMaterialStalhrimHeavy != undefined || a_entryObject.keywords.DLC2ArmorMaterialStalhrimLight != undefined || a_entryObject.keywords.DLC2WeaponMaterialStalhrim != undefined)
      {
         a_entryObject.material = skyui.defines.Material.STALHRIM;
         a_entryObject.materialDisplay = skyui.util.Translator.translate("$Stalhrim");
      }
      else if(a_entryObject.keywords.WeapMaterialFalmer != undefined || a_entryObject.keywords.WeapMaterialFalmerHoned != undefined)
      {
         a_entryObject.material = skyui.defines.Material.FALMER;
         a_entryObject.materialDisplay = skyui.util.Translator.translate("$Falmer");
      }
      else if(a_entryObject.keywords.ccASVSSE001_ArmorOrdinator != undefined || a_entryObject.keywords.ccASVSSE001_ArmorOrdinatorIndoril != undefined)
      {
         a_entryObject.material = skyui.defines.Material.ORDINATOR;
         a_entryObject.materialDisplay = skyui.util.Translator.translate("$Ordinator");
      }
      else if(a_entryObject.keywords.ccBGSSSE025_ArmorMaterialAmber != undefined || a_entryObject.keywords.ccBGSSSE025_WeapMaterialAmber != undefined)
      {
         a_entryObject.material = skyui.defines.Material.AMBER;
         a_entryObject.materialDisplay = skyui.util.Translator.translate("$Amber");
      }
      else if(a_entryObject.keywords.ccBGSSSE025_ArmorMaterialMadness != undefined || a_entryObject.keywords.ccBGSSSE025_WeapMaterialMadness != undefined)
      {
         a_entryObject.material = skyui.defines.Material.MADNESS;
         a_entryObject.materialDisplay = skyui.util.Translator.translate("$Madness");
      }
      else if(a_entryObject.keywords.WeapMaterialWood != undefined)
      {
         a_entryObject.material = skyui.defines.Material.WOOD;
         a_entryObject.materialDisplay = skyui.util.Translator.translate("$Wood");
      }
      else if(a_entryObject.keywords.ArmorJewelry != undefined)
      {
         a_entryObject.material = null;
         a_entryObject.materialDisplay = null;
      }
      else if(a_entryObject.keywords.ArmorClothing != undefined)
      {
         a_entryObject.material = null;
         a_entryObject.materialDisplay = null;
      }
   }
   function processWeaponType(a_entryObject)
   {
      a_entryObject.subType = null;
      a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Weapon");
      if(a_entryObject.keywords != undefined && a_entryObject.keywords.ccBGSSSE001_FishingPoleKW != undefined)
      {
         a_entryObject.subType = skyui.defines.Weapon.TYPE_FISHINGROD;
         a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$FishingRod");
         return;
      }
      switch(a_entryObject.weaponType)
      {
         case skyui.defines.Weapon.ANIM_HANDTOHANDMELEE:
         case skyui.defines.Weapon.ANIM_H2H:
            a_entryObject.subType = skyui.defines.Weapon.TYPE_MELEE;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Melee");
            break;
         case skyui.defines.Weapon.ANIM_ONEHANDSWORD:
         case skyui.defines.Weapon.ANIM_1HS:
            a_entryObject.subType = skyui.defines.Weapon.TYPE_SWORD;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Sword");
            break;
         case skyui.defines.Weapon.ANIM_ONEHANDDAGGER:
         case skyui.defines.Weapon.ANIM_1HD:
            a_entryObject.subType = skyui.defines.Weapon.TYPE_DAGGER;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Dagger");
            break;
         case skyui.defines.Weapon.ANIM_ONEHANDAXE:
         case skyui.defines.Weapon.ANIM_1HA:
            a_entryObject.subType = skyui.defines.Weapon.TYPE_WARAXE;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$War Axe");
            break;
         case skyui.defines.Weapon.ANIM_ONEHANDMACE:
         case skyui.defines.Weapon.ANIM_1HM:
            a_entryObject.subType = skyui.defines.Weapon.TYPE_MACE;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Mace");
            break;
         case skyui.defines.Weapon.ANIM_TWOHANDSWORD:
         case skyui.defines.Weapon.ANIM_2HS:
            a_entryObject.subType = skyui.defines.Weapon.TYPE_GREATSWORD;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Greatsword");
            break;
         case skyui.defines.Weapon.ANIM_TWOHANDAXE:
         case skyui.defines.Weapon.ANIM_2HA:
            a_entryObject.subType = skyui.defines.Weapon.TYPE_BATTLEAXE;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Battleaxe");
            if(a_entryObject.keywords != undefined && a_entryObject.keywords.WeapTypeWarhammer != undefined)
            {
               a_entryObject.subType = skyui.defines.Weapon.TYPE_WARHAMMER;
               a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Warhammer");
            }
            break;
         case skyui.defines.Weapon.ANIM_BOW:
         case skyui.defines.Weapon.ANIM_BOW2:
            a_entryObject.subType = skyui.defines.Weapon.TYPE_BOW;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Bow");
            break;
         case skyui.defines.Weapon.ANIM_STAFF:
         case skyui.defines.Weapon.ANIM_STAFF2:
            a_entryObject.subType = skyui.defines.Weapon.TYPE_STAFF;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Staff");
            break;
         case skyui.defines.Weapon.ANIM_CROSSBOW:
         case skyui.defines.Weapon.ANIM_CBOW:
            a_entryObject.subType = skyui.defines.Weapon.TYPE_CROSSBOW;
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
            a_entryObject.subType = skyui.defines.Weapon.TYPE_PICKAXE;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Pickaxe");
            break;
         case skyui.defines.Form.BASEID_AXE01:
         case skyui.defines.Form.BASEID_DUNHALTEDSTREAMPOACHERSAXE:
            a_entryObject.subType = skyui.defines.Weapon.TYPE_WOODAXE;
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
            a_entryObject.subType = skyui.defines.Armor.EQUIP_HEAD;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Head");
            return;
         case skyui.defines.Armor.PARTMASK_HAIR:
            a_entryObject.subType = skyui.defines.Armor.EQUIP_HAIR;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Head");
            return;
         case skyui.defines.Armor.PARTMASK_LONGHAIR:
            a_entryObject.subType = skyui.defines.Armor.EQUIP_LONGHAIR;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Head");
            return;
         case skyui.defines.Armor.PARTMASK_BODY:
            a_entryObject.subType = skyui.defines.Armor.EQUIP_BODY;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Body");
            return;
         case skyui.defines.Armor.PARTMASK_HANDS:
            a_entryObject.subType = skyui.defines.Armor.EQUIP_HANDS;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Hands");
            return;
         case skyui.defines.Armor.PARTMASK_FOREARMS:
            a_entryObject.subType = skyui.defines.Armor.EQUIP_FOREARMS;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Forearms");
            return;
         case skyui.defines.Armor.PARTMASK_AMULET:
            a_entryObject.subType = skyui.defines.Armor.EQUIP_AMULET;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Amulet");
            return;
         case skyui.defines.Armor.PARTMASK_RING:
            a_entryObject.subType = skyui.defines.Armor.EQUIP_RING;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Ring");
            return;
         case skyui.defines.Armor.PARTMASK_FEET:
            a_entryObject.subType = skyui.defines.Armor.EQUIP_FEET;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Feet");
            return;
         case skyui.defines.Armor.PARTMASK_CALVES:
            a_entryObject.subType = skyui.defines.Armor.EQUIP_CALVES;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Calves");
            return;
         case skyui.defines.Armor.PARTMASK_SHIELD:
            a_entryObject.subType = skyui.defines.Armor.EQUIP_SHIELD;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Shield");
            return;
         case skyui.defines.Armor.PARTMASK_CIRCLET:
            a_entryObject.subType = skyui.defines.Armor.EQUIP_CIRCLET;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Circlet");
            return;
         case skyui.defines.Armor.PARTMASK_EARS:
            a_entryObject.subType = skyui.defines.Armor.EQUIP_EARS;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Ears");
            return;
         case skyui.defines.Armor.PARTMASK_TAIL:
            a_entryObject.subType = skyui.defines.Armor.EQUIP_TAIL;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Tail");
            return;
         case skyui.defines.Armor.PARTMASK_BACKPACK:
            a_entryObject.subType = skyui.defines.Armor.EQUIP_BACKPACK;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Backpack");
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
         case skyui.defines.Armor.PARTMASK_BACKPACK:
            a_entryObject.weightClass = skyui.defines.Armor.WEIGHT_CLOTHING;
            a_entryObject.weightClassDisplay = skyui.util.Translator.translate("$Clothing");
            break;
         case skyui.defines.Armor.PARTMASK_AMULET:
         case skyui.defines.Armor.PARTMASK_RING:
         case skyui.defines.Armor.PARTMASK_CIRCLET:
         case skyui.defines.Armor.PARTMASK_EARS:
            a_entryObject.weightClass = skyui.defines.Armor.WEIGHT_JEWELRY;
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
            a_entryObject.weightClass = skyui.defines.Armor.WEIGHT_JEWELRY;
            a_entryObject.weightClassDisplay = skyui.util.Translator.translate("$Jewelry");
            break;
         case skyui.defines.Form.BASEID_DLC1CLOTHESVAMPIRELORDARMOR:
            a_entryObject.subType = skyui.defines.Armor.EQUIP_BODY;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Body");
         default:
            return;
      }
   }
   function processBookType(a_entryObject)
   {
      a_entryObject.subType = skyui.defines.Item.OTHER;
      a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Book");
      a_entryObject.isRead = (a_entryObject.flags & skyui.defines.Item.BOOKFLAG_READ) != 0;
      if(a_entryObject.bookType == skyui.defines.Item.BOOKTYPE_NOTE)
      {
         a_entryObject.subType = skyui.defines.Item.BOOK_NOTE;
         a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Note");
      }
      if(a_entryObject.keywords == undefined)
      {
         return undefined;
      }
      if(a_entryObject.keywords.VendorItemRecipe != undefined)
      {
         a_entryObject.subType = skyui.defines.Item.BOOK_RECIPE;
         a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Recipe");
      }
      else if(a_entryObject.keywords.VendorItemSpellTome != undefined)
      {
         a_entryObject.subType = skyui.defines.Item.BOOK_SPELLTOME;
         a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Spell Tome");
      }
   }
   function processAmmoType(a_entryObject)
   {
      if((a_entryObject.flags & skyui.defines.Weapon.AMMOFLAG_NONBOLT) != 0)
      {
         a_entryObject.subType = skyui.defines.Weapon.AMMO_ARROW;
         a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Arrow");
      }
      else
      {
         a_entryObject.subType = skyui.defines.Weapon.AMMO_BOLT;
         a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Bolt");
      }
   }
   function processAmmoBaseId(a_entryObject)
   {
      switch(a_entryObject.baseId)
      {
         case skyui.defines.Form.BASEID_DAEDRICARROW:
            a_entryObject.material = skyui.defines.Material.DAEDRIC;
            a_entryObject.materialDisplay = skyui.util.Translator.translate("$Daedric");
            break;
         case skyui.defines.Form.BASEID_EBONYARROW:
            a_entryObject.material = skyui.defines.Material.EBONY;
            a_entryObject.materialDisplay = skyui.util.Translator.translate("$Ebony");
            break;
         case skyui.defines.Form.BASEID_GLASSARROW:
            a_entryObject.material = skyui.defines.Material.GLASS;
            a_entryObject.materialDisplay = skyui.util.Translator.translate("$Glass");
            break;
         case skyui.defines.Form.BASEID_ELVENARROW:
         case skyui.defines.Form.BASEID_DLC1ELVENARROWBLESSED:
         case skyui.defines.Form.BASEID_DLC1ELVENARROWBLOOD:
            a_entryObject.material = skyui.defines.Material.ELVEN;
            a_entryObject.materialDisplay = skyui.util.Translator.translate("$Elven");
            break;
         case skyui.defines.Form.BASEID_DWARVENARROW:
         case skyui.defines.Form.BASEID_DWARVENSPHEREARROW:
         case skyui.defines.Form.BASEID_DWARVENSPHEREBOLT01:
         case skyui.defines.Form.BASEID_DWARVENSPHEREBOLT02:
         case skyui.defines.Form.BASEID_DLC2DWARVENBALLISTABOLT:
            a_entryObject.material = skyui.defines.Material.DWARVEN;
            a_entryObject.materialDisplay = skyui.util.Translator.translate("$Dwarven");
            break;
         case skyui.defines.Form.BASEID_ORCISHARROW:
            a_entryObject.material = skyui.defines.Material.ORCISH;
            a_entryObject.materialDisplay = skyui.util.Translator.translate("$Orcish");
            break;
         case skyui.defines.Form.BASEID_NORDHEROARROW:
            a_entryObject.material = skyui.defines.Material.NORDIC;
            a_entryObject.materialDisplay = skyui.util.Translator.translate("$Nordic");
            break;
         case skyui.defines.Form.BASEID_FALMERARROW:
            a_entryObject.material = skyui.defines.Material.FALMER;
            a_entryObject.materialDisplay = skyui.util.Translator.translate("$Falmer");
            break;
         case skyui.defines.Form.BASEID_STEELARROW:
         case skyui.defines.Form.BASEID_MQ101STEELARROW:
         case skyui.defines.Form.BASEID_DRAUGRARROW:
         case skyui.defines.Form.BASEID_DUNGEIRMUNDSIGDISARROWSILLUSION:
            a_entryObject.material = skyui.defines.Material.STEEL;
            a_entryObject.materialDisplay = skyui.util.Translator.translate("$Steel");
            break;
         case skyui.defines.Form.BASEID_IRONARROW:
         case skyui.defines.Form.BASEID_CWARROW:
         case skyui.defines.Form.BASEID_CWARROWSHORT:
         case skyui.defines.Form.BASEID_TRAPDART:
         case skyui.defines.Form.BASEID_DUNARCHERPRATICEARROW:
         case skyui.defines.Form.BASEID_FOLLOWERIRONARROW:
         case skyui.defines.Form.BASEID_TESTDLC1BOLT:
            a_entryObject.material = skyui.defines.Material.IRON;
            a_entryObject.materialDisplay = skyui.util.Translator.translate("$Iron");
            break;
         case skyui.defines.Form.BASEID_DLC2RIEKLINGSPEARTHROWN:
            a_entryObject.material = skyui.defines.Material.WOOD;
            a_entryObject.materialDisplay = skyui.util.Translator.translate("$Wood");
         default:
            return;
      }
   }
   function processKeyType(a_entryObject)
   {
      a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Key");
      if(a_entryObject.infoValue <= 0)
      {
         a_entryObject.infoValue = null;
      }
      if(a_entryObject.infoValue <= 0)
      {
         a_entryObject.infoValue = null;
      }
   }
   function processPotionType(a_entryObject)
   {
      a_entryObject.subType = skyui.defines.Item.POTION_POTION;
      a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Potion");
      if((a_entryObject.flags & skyui.defines.Item.ALCHFLAG_FOOD) != 0)
      {
         a_entryObject.subType = skyui.defines.Item.POTION_FOOD;
         a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Food");
         if(a_entryObject.useSound.formId != undefined && a_entryObject.useSound.formId == skyui.defines.Form.FORMID_ITMPotionUse)
         {
            a_entryObject.subType = skyui.defines.Item.POTION_DRINK;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Drink");
         }
      }
      else if((a_entryObject.flags & skyui.defines.Item.ALCHFLAG_POISON) != 0)
      {
         a_entryObject.subType = skyui.defines.Item.POTION_POISON;
         a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Poison");
      }
      else
      {
         switch(a_entryObject.actorValue)
         {
            case skyui.defines.Actor.AV_HEALTH:
               a_entryObject.subType = skyui.defines.Item.POTION_HEALTH;
               a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Health");
               break;
            case skyui.defines.Actor.AV_MAGICKA:
               a_entryObject.subType = skyui.defines.Item.POTION_MAGICKA;
               a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Magicka");
               break;
            case skyui.defines.Actor.AV_STAMINA:
               a_entryObject.subType = skyui.defines.Item.POTION_STAMINA;
               a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Stamina");
               break;
            case skyui.defines.Actor.AV_HEALRATE:
               a_entryObject.subType = skyui.defines.Item.POTION_HEALRATE;
               a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Health");
               break;
            case skyui.defines.Actor.AV_MAGICKARATE:
               a_entryObject.subType = skyui.defines.Item.POTION_MAGICKARATE;
               a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Magicka");
               break;
            case skyui.defines.Actor.AV_STAMINARATE:
               a_entryObject.subType = skyui.defines.Item.POTION_STAMINARATE;
               a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Stamina");
               break;
            case skyui.defines.Actor.AV_HEALRATEMULT:
               a_entryObject.subType = skyui.defines.Item.POTION_HEALRATEMULT;
               a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Health");
               break;
            case skyui.defines.Actor.AV_MAGICKARATEMULT:
               a_entryObject.subType = skyui.defines.Item.POTION_MAGICKARATEMULT;
               a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Magicka");
               break;
            case skyui.defines.Actor.AV_STAMINARATEMULT:
               a_entryObject.subType = skyui.defines.Item.POTION_STAMINARATEMULT;
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
      a_entryObject.subType = skyui.defines.Item.OTHER;
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
      if(a_entryObject.soulSize != undefined)
      {
         switch(a_entryObject.soulSize)
         {
            case skyui.defines.Item.SOULGEM_NONE:
               a_entryObject.soulSizeDisplay = null;
               break;
            case skyui.defines.Item.SOULGEM_PETTY:
               a_entryObject.soulSizeDisplay = "$Petty";
               break;
            case skyui.defines.Item.SOULGEM_LESSER:
               a_entryObject.soulSizeDisplay = "$Lesser";
               break;
            case skyui.defines.Item.SOULGEM_COMMON:
               a_entryObject.soulSizeDisplay = "$Common";
               break;
            case skyui.defines.Item.SOULGEM_GREATER:
               a_entryObject.soulSizeDisplay = "$Greater";
               break;
            case skyui.defines.Item.SOULGEM_GRAND:
            case skyui.defines.Item.SOULGEM_AZURA:
               a_entryObject.soulSizeDisplay = "$Grand";
            default:
               return;
         }
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
      a_entryObject.subType = skyui.defines.Item.OTHER;
      a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Misc");
      if(a_entryObject.keywords == undefined)
      {
         return undefined;
      }
      if(a_entryObject.keywords.BYOHAdoptionClothesKeyword != undefined)
      {
         a_entryObject.subType = skyui.defines.Item.MISC_CHILDRENSCLOTHES;
         a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Clothing");
      }
      else if(a_entryObject.keywords.BYOHAdoptionToyKeyword != undefined)
      {
         a_entryObject.subType = skyui.defines.Item.MISC_TOY;
         a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Toy");
      }
      else if(a_entryObject.keywords.BYOHHouseCraftingCategoryWeaponRacks != undefined || a_entryObject.keywords.BYOHHouseCraftingCategoryShelf != undefined || a_entryObject.keywords.BYOHHouseCraftingCategoryFurniture != undefined || a_entryObject.keywords.BYOHHouseCraftingCategoryExterior != undefined || a_entryObject.keywords.BYOHHouseCraftingCategoryContainers != undefined || a_entryObject.keywords.BYOHHouseCraftingCategoryBuilding != undefined || a_entryObject.keywords.BYOHHouseCraftingCategorySmithing != undefined)
      {
         a_entryObject.subType = skyui.defines.Item.MISC_HOUSEPART;
         a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$House Part");
      }
      else if(a_entryObject.keywords.VendorItemDaedricArtifact != undefined)
      {
         a_entryObject.subType = skyui.defines.Item.MISC_ARTIFACT;
         a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Artifact");
      }
      else if(a_entryObject.keywords.VendorItemGem != undefined)
      {
         a_entryObject.subType = skyui.defines.Item.MISC_GEM;
         a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Gem");
      }
      else if(a_entryObject.keywords.VendorItemAnimalHide != undefined)
      {
         a_entryObject.subType = skyui.defines.Item.MISC_HIDE;
         a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Hide");
      }
      else if(a_entryObject.keywords.VendorItemTool != undefined)
      {
         a_entryObject.subType = skyui.defines.Item.MISC_TOOL;
         a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Tool");
      }
      else if(a_entryObject.keywords.VendorItemAnimalPart != undefined)
      {
         a_entryObject.subType = skyui.defines.Item.MISC_REMAINS;
         a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Remains");
      }
      else if(a_entryObject.keywords.VendorItemOreIngot != undefined)
      {
         a_entryObject.subType = skyui.defines.Item.MISC_INGOT;
         a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Ingot");
      }
      else if(a_entryObject.keywords.VendorItemFireword != undefined)
      {
         a_entryObject.subType = skyui.defines.Item.MISC_FIREWOOD;
         a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Firewood");
      }
      else if(a_entryObject.keywords.VendorItemClutter != undefined)
      {
         a_entryObject.subType = skyui.defines.Item.MISC_CLUTTER;
         a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Clutter");
      }

   }
   function processMiscBaseId(a_entryObject)
   {
      switch(a_entryObject.baseId)
      {
         case skyui.defines.Form.BASEID_GEMAMETHYSTFLAWLESS:
            a_entryObject.subType = skyui.defines.Item.MISC_GEM;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Gem");
            break;
         case skyui.defines.Form.BASEID_DLC2DRAGONCLAW1:
         case skyui.defines.Form.BASEID_DLC2DRAGONCLAW2:
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
            a_entryObject.subType = skyui.defines.Item.MISC_DRAGONCLAW;
            break;
         case skyui.defines.Form.BASEID_GEM1:
         case skyui.defines.Form.BASEID_GEM2:
         case skyui.defines.Form.BASEID_GEM3:
         case skyui.defines.Form.BASEID_GEM4:
         case skyui.defines.Form.BASEID_DLC1GEM1:
         case skyui.defines.Form.BASEID_DLC1GEM2:
         case skyui.defines.Form.BASEID_DLC1GEM3:
         case skyui.defines.Form.BASEID_DLC1GEM4:
         case skyui.defines.Form.BASEID_DLC1GEM5:
         case skyui.defines.Form.BASEID_DLC2GEM1:
         case skyui.defines.Form.BASEID_DLC2GEM2:
         case skyui.defines.Form.BASEID_DLC2GEM3:
         case skyui.defines.Form.BASEID_DLC2GEM4:
         case skyui.defines.Form.BASEID_DLC2GEM5:
         case skyui.defines.Form.BASEID_CCALMSIVIGEM1:
         case skyui.defines.Form.BASEID_CCALMSIVIGEM2:
         case skyui.defines.Form.BASEID_CCALMSIVIGEM3:
         case skyui.defines.Form.BASEID_CCALMSIVIGEM4:
            a_entryObject.subType = skyui.defines.Item.MISC_GEM;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Gem");
            break;
         case skyui.defines.Form.BASEID_REMAINS1:
         case skyui.defines.Form.BASEID_REMAINS2:
         case skyui.defines.Form.BASEID_REMAINS3:
         case skyui.defines.Form.BASEID_REMAINS4:
         case skyui.defines.Form.BASEID_REMAINS5:
         case skyui.defines.Form.BASEID_DLC1REMAINS1:
         case skyui.defines.Form.BASEID_DLC1REMAINS2:
         case skyui.defines.Form.BASEID_DLC1REMAINS3:
         case skyui.defines.Form.BASEID_DLC1REMAINS4:
         case skyui.defines.Form.BASEID_DLC1REMAINS5:
         case skyui.defines.Form.BASEID_DLC1REMAINS6:
         case skyui.defines.Form.BASEID_DLC1REMAINS7:
            a_entryObject.subType = skyui.defines.Item.MISC_REMAINS;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Remains");
            break;
         case skyui.defines.Form.BASEID_DLC2TROLLSKULL:
            a_entryObject.subType = skyui.defines.Item.MISC_TROLLSKULL;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Remains");
            break;
         case skyui.defines.Form.BASEID_LOCKPICK:
            a_entryObject.subType = skyui.defines.Item.MISC_LOCKPICK;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Lockpick");
            break;
         case skyui.defines.Form.BASEID_GOLD001:
            a_entryObject.subType = skyui.defines.Item.MISC_GOLD;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Gold");
            break;
         case skyui.defines.Form.BASEID_LEATHER01:
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Leather");
            a_entryObject.subType = skyui.defines.Item.MISC_LEATHER;
            break;
         case skyui.defines.Form.BASEID_LEATHERSTRIPS:
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Strips");
            a_entryObject.subType = skyui.defines.Item.MISC_LEATHERSTRIPS;
            break;
         case 0x3AD57:
         case 0x195AA:
         case 0x2B04E:
            a_entryObject.subType = skyui.defines.Item.MISC_NETCHLEATHER;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$NetchLeather");
            break;
         case 0x3043:
         case 0x3035:
         case 0x5A69:
         case 0x3011:
         case 0x303F:
         case 0x3012:
         case 0x300E:
         case 0x300F:
         case 0x306C:
         case 0x5A68:
            a_entryObject.subType = skyui.defines.Item.MISC_HOUSEPART;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$BuildingMaterial");
            break;
         case 0xE72AA:
         case 0xE72AC:
         case 0xE72B0:
         case 0xE72AE:
         case 0xE72A6:
         case 0xE72A8:
         case 0xE72A0:
         case 0xE729E:
         case 0xE729A:
         case 0xE729C:
         case 0xE7296:
         case 0xE7298:
         case 0xE72A4:
         case 0xE72A2:
         case 0x64283:
         case 0x64285:
         case 0x64287:
         case 0x64289:
         case 0x6428B:
         case 0x6428E:
         case 0x64290:
         case 0x64292:
         case 0x64294:
         case 0x64296:
         case 0x64298:
         case 0x6E806:
         case 0xDB351:
         case 0x240D3:
         case 0x240D4:
         case 0x240D5:
         case 0x240D6:
            a_entryObject.subType = skyui.defines.Item.MISC_BROKENWEAPON;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$BrokenWeapon");
            break;
         case 0x809:
         case 0x762B7:
         case 0x762B8:
         case 0x762B9:
         case 0x762BA:
         case 0xBDB37:
            a_entryObject.subType = skyui.defines.Item.MISC_AYLEIDCRYSTAL;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$AyleidCrystal");
            break;
         case 0x30C9:
         case 0x30CA:
         case 0x723B8:
            a_entryObject.subType = skyui.defines.Item.MISC_HORSETACK;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$HorseTack");
            break;
         case 0xC886C:
         case 0xC8878:
         case 0xC8864:
         case 0xC8872:
         case 0xC8866:
         case 0xC8874:
         case 0xC886A:
         case 0xAEBF1:
         case 0xC8861:
         case 0xC8868:
         case 0xC886E:
         case 0xC8870:
         case 0x804:
            a_entryObject.subType = skyui.defines.Item.MISC_DWARVENSCRAP;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$DwarvenScrap");
            break;
         case 0xDABA9:
         case 0xDABA7:
         case 0x105177:
         case 0x3292F:
         case 0x200BA:
         case 0xDABAB:
         case 0x200B6:
         case 0x105109:
         case 0xE77BB:
         case 0xCE153:
         case 0x8AD49:
         case 0x67855:
            a_entryObject.subType = skyui.defines.Item.MISC_INSTRUMENT;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Instrument");
            break;
         case 0xB08C7:
         case 0xFBC3A:
         case 0xFBC3B:
         case 0xFBC3C:
         case 0xFBC3D:
         case 0x12DD3A:
         case 0x12DD3B:
         case 0x12DD3C:
            a_entryObject.subType = skyui.defines.Item.MISC_BUGJAR;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$BugJar");
            break;
         case 0x17719:
         case 0x1771F:
            a_entryObject.subType = skyui.defines.Item.MISC_SCROLLSPIDER;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$ScrollSpider");
            break;
         case 0x1CD7C:
            a_entryObject.subType = skyui.defines.Item.MISC_NETCHLEATHER;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$NetchLeather");
            break;
         case 0x60CC2:
         case 0xBBCD5:
         case 0x2BAAE:
         case 0x80D:
         case 0xE29A:
            a_entryObject.subType = skyui.defines.Item.MISC_MAP;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Map");
            break;
         case 0x2C259:
         case 0x2C25A:
            a_entryObject.subType = skyui.defines.Item.MISC_ARTIFACT;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Artifact");
            break;
         case 0xC4F2E:
         case 0x82F:
            a_entryObject.subType = skyui.defines.Item.MISC_POTION;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Potion");
            break;
         case 0x2BAAB:
            a_entryObject.subType = skyui.defines.Item.MISC_POISON;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Poison");
            break;
         case 0x457AB:
         case 0xDC530:
         case 0xDC52E:
         case 0x13201:
         case 0x13202:
            a_entryObject.subType = skyui.defines.Item.MISC_SCROLL;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Scroll");
            break;
         case 0xF1491:
         case 0xCE70B:
         case 0xE4897:
         case 0xE3CB7:
            a_entryObject.subType = skyui.defines.Item.MISC_BOOK;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Book");
            break;
         case 0x1CB34:
         case 0xDA732:
         case 0xDA733:
         case 0xDA734:
         case 0xDA735:
            a_entryObject.subType = skyui.defines.Item.MISC_RING;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Ring");
            break;
         case 0x1AAD6:
         case 0x8B2:
         case 0x8B8:
         case 0x8B9:
         case 0x8BA:
         case 0x8BB:
         case 0x8BC:
         case 0x8BD:
         case 0x8BE:
         case 0x8BF:
         case 0x8C3:
         case 0x8C4:
         case 0x8C5:
            a_entryObject.subType = skyui.defines.Item.MISC_INGREDIENT;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Ingredient");
            break;
         case 0x5ACDB:
         case 0x5ACDC:
         case 0x5ACDE:
         case 0x71CF3:
         case 0x5ACE1:
         case 0x5ACE0:
         case 0x5ACDD:
         case 0x5ACE2:
         case 0x5B2DF:
         case 0x5ACDF:
         case 0x2B06B:
         case 0x17749:
         case 0x195A9:
         case 0xBC6:
         case 0xBC9:
            a_entryObject.subType = skyui.defines.Item.MISC_ORE;
            a_entryObject.subTypeDisplay = skyui.util.Translator.translate("$Ore");
         default:
            return;
      }
   }
   function fixSKSEExtendedObject(a_extendedObject)
   {
      if(a_extendedObject.formType == undefined)
      {
         return undefined;
      }
      var _loc2_;
      switch(a_extendedObject.formType)
      {
         case skyui.defines.Form.TYPE_SPELL:
         case skyui.defines.Form.TYPE_SCROLLITEM:
         case skyui.defines.Form.TYPE_INGREDIENT:
         case skyui.defines.Form.TYPE_POTION:
         case skyui.defines.Form.TYPE_EFFECTSETTING:
            if(a_extendedObject.school == undefined && a_extendedObject.subType != undefined)
            {
               a_extendedObject.school = a_extendedObject.subType;
               delete a_extendedObject.subType;
            }
            if(a_extendedObject.resistance == undefined && a_extendedObject.magicType != undefined)
            {
               a_extendedObject.resistance = a_extendedObject.magicType;
               delete a_extendedObject.magicType;
            }
            break;
         case skyui.defines.Form.TYPE_WEAPON:
            if(a_extendedObject.weaponType == undefined && a_extendedObject.subType != undefined)
            {
               a_extendedObject.weaponType = a_extendedObject.subType;
               delete a_extendedObject.subType;
            }
            break;
         case skyui.defines.Form.TYPE_BOOK:
            if(a_extendedObject.flags == undefined && a_extendedObject.bookType != undefined)
            {
               _loc2_ = a_extendedObject.bookType;
               a_extendedObject.bookType = (_loc2_ & 0xFF00) >>> 8;
               a_extendedObject.flags = _loc2_ & 0xFF;
            }
         default:
            return;
      }
   }
}
