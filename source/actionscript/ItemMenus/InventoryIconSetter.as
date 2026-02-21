class InventoryIconSetter implements skyui.components.list.IListProcessor
{
   var _noIconColors;
   function InventoryIconSetter(a_configAppearance)
   {
      this._noIconColors = a_configAppearance.icons.item.noColor;
   }
   function processList(a_list)
   {
      var _loc3_ = a_list.entryList;
      var _loc2_ = 0;
      while(_loc2_ < _loc3_.length)
      {
         this.processEntry(_loc3_[_loc2_]);
         _loc2_ = _loc2_ + 1;
      }
   }
   function processEntry(a_entryObject)
   {
      switch(a_entryObject.formType)
      {
         case skyui.defines.Form.TYPE_SCROLLITEM:
            a_entryObject.iconLabel = "default_scroll";
            this.processResist(a_entryObject);
            this.processScrollBaseIdIcon(a_entryObject);
            break;
         case skyui.defines.Form.TYPE_ARMOR:
            this.processArmorIcon(a_entryObject);
            break;
         case skyui.defines.Form.TYPE_BOOK:
            this.processBookIcon(a_entryObject);
            this.processBookBaseIdIcon(a_entryObject);
            break;
         case skyui.defines.Form.TYPE_INGREDIENT:
            a_entryObject.iconLabel = "default_ingredient";
            break;
         case skyui.defines.Form.TYPE_LIGHT:
            a_entryObject.iconLabel = "misc_torch";
            break;
         case skyui.defines.Form.TYPE_MISC:
            this.processMiscIcon(a_entryObject);
            this.processMiscBaseIdIcon(a_entryObject);
            break;
         case skyui.defines.Form.TYPE_WEAPON:
            this.processWeaponIcon(a_entryObject);
            break;
         case skyui.defines.Form.TYPE_AMMO:
            this.processAmmoIcon(a_entryObject);
            break;
         case skyui.defines.Form.TYPE_KEY:
            a_entryObject.iconLabel = "default_key";
            break;
         case skyui.defines.Form.TYPE_POTION:
            this.processPotionIcon(a_entryObject);
            this.processPotionBaseIdIcon(a_entryObject);
            break;
         case skyui.defines.Form.TYPE_SOULGEM:
            this.processSoulGemIcon(a_entryObject);
            this.processSoulGemBaseIdIcon(a_entryObject);
      }
      if(this._noIconColors && a_entryObject.iconColor != undefined)
      {
         delete a_entryObject.iconColor;
      }
   }
   function processResist(a_entryObject)
   {
      if(a_entryObject.resistance == undefined || a_entryObject.resistance == skyui.defines.Actor.AV_NONE)
      {
         return undefined;
      }
      switch(a_entryObject.resistance)
      {
         case skyui.defines.Actor.AV_FIRERESIST:
            a_entryObject.iconColor = 13055542;
            break;
         case skyui.defines.Actor.AV_ELECTRICRESIST:
            a_entryObject.iconColor = 16776960;
            break;
         case skyui.defines.Actor.AV_FROSTRESIST:
            a_entryObject.iconColor = 2096127;
         default:
            return;
      }
   }
   function processArmorIcon(a_entryObject)
   {
      a_entryObject.iconLabel = "default_armor";
      a_entryObject.iconColor = 15587975;
      if(a_entryObject.subType == skyui.defines.Armor.EQUIP_BACK)
      {
         a_entryObject.iconLabel = "clothing_backpack";
         return;
      }
      switch(a_entryObject.weightClass)
      {
         case skyui.defines.Armor.WEIGHT_LIGHT:
            this.processLightArmorIcon(a_entryObject);
            return;
         case skyui.defines.Armor.WEIGHT_HEAVY:
            this.processHeavyArmorIcon(a_entryObject);
            return;
         case skyui.defines.Armor.WEIGHT_JEWELRY:
            this.processJewelryArmorIcon(a_entryObject);
            return;
         case skyui.defines.Armor.WEIGHT_CLOTHING:
         default:
            this.processClothingArmorIcon(a_entryObject);
            return;
      }
   }
   function processLightArmorIcon(a_entryObject)
   {
      a_entryObject.iconColor = 7692288;
      switch(a_entryObject.subType)
      {
         case skyui.defines.Armor.EQUIP_HEAD:
         case skyui.defines.Armor.EQUIP_HAIR:
         case skyui.defines.Armor.EQUIP_LONGHAIR:
            a_entryObject.iconLabel = "lightarmor_head";
            break;
         case skyui.defines.Armor.EQUIP_BODY:
         case skyui.defines.Armor.EQUIP_TAIL:
            a_entryObject.iconLabel = "lightarmor_body";
            break;
         case skyui.defines.Armor.EQUIP_HANDS:
            a_entryObject.iconLabel = "lightarmor_hands";
            break;
         case skyui.defines.Armor.EQUIP_FOREARMS:
            a_entryObject.iconLabel = "lightarmor_forearms";
            break;
         case skyui.defines.Armor.EQUIP_FEET:
            a_entryObject.iconLabel = "lightarmor_feet";
            break;
         case skyui.defines.Armor.EQUIP_CALVES:
            a_entryObject.iconLabel = "lightarmor_calves";
            break;
         case skyui.defines.Armor.EQUIP_SHIELD:
            a_entryObject.iconLabel = "lightarmor_shield";
            break;
         case skyui.defines.Armor.EQUIP_AMULET:
         case skyui.defines.Armor.EQUIP_RING:
         case skyui.defines.Armor.EQUIP_CIRCLET:
         case skyui.defines.Armor.EQUIP_EARS:
            this.processJewelryArmorIcon(a_entryObject);
         default:
            return;
      }
   }
   function processHeavyArmorIcon(a_entryObject)
   {
      a_entryObject.iconColor = 7042437;
      switch(a_entryObject.subType)
      {
         case skyui.defines.Armor.EQUIP_HEAD:
         case skyui.defines.Armor.EQUIP_HAIR:
         case skyui.defines.Armor.EQUIP_LONGHAIR:
            a_entryObject.iconLabel = "armor_head";
            break;
         case skyui.defines.Armor.EQUIP_BODY:
         case skyui.defines.Armor.EQUIP_TAIL:
            a_entryObject.iconLabel = "armor_body";
            break;
         case skyui.defines.Armor.EQUIP_HANDS:
            a_entryObject.iconLabel = "armor_hands";
            break;
         case skyui.defines.Armor.EQUIP_FOREARMS:
            a_entryObject.iconLabel = "armor_forearms";
            break;
         case skyui.defines.Armor.EQUIP_FEET:
            a_entryObject.iconLabel = "armor_feet";
            break;
         case skyui.defines.Armor.EQUIP_CALVES:
            a_entryObject.iconLabel = "armor_calves";
            break;
         case skyui.defines.Armor.EQUIP_SHIELD:
            a_entryObject.iconLabel = "armor_shield";
            break;
         case skyui.defines.Armor.EQUIP_AMULET:
         case skyui.defines.Armor.EQUIP_RING:
         case skyui.defines.Armor.EQUIP_CIRCLET:
         case skyui.defines.Armor.EQUIP_EARS:
            this.processJewelryArmorIcon(a_entryObject);
         default:
            return;
      }
   }
   function processJewelryArmorIcon(a_entryObject)
   {
      switch(a_entryObject.subType)
      {
         case skyui.defines.Armor.EQUIP_AMULET:
            a_entryObject.iconLabel = "armor_amulet";
            break;
         case skyui.defines.Armor.EQUIP_RING:
            a_entryObject.iconLabel = "armor_ring";
            break;
         case skyui.defines.Armor.EQUIP_CIRCLET:
            a_entryObject.iconLabel = "armor_circlet";
         case skyui.defines.Armor.EQUIP_EARS:
         default:
            return;
      }
   }
   function processClothingArmorIcon(a_entryObject)
   {
      switch(a_entryObject.subType)
      {
         case skyui.defines.Armor.EQUIP_HEAD:
         case skyui.defines.Armor.EQUIP_HAIR:
         case skyui.defines.Armor.EQUIP_LONGHAIR:
            a_entryObject.iconLabel = "clothing_head";
            break;
         case skyui.defines.Armor.EQUIP_BODY:
         case skyui.defines.Armor.EQUIP_TAIL:
            a_entryObject.iconLabel = "clothing_body";
            break;
         case skyui.defines.Armor.EQUIP_HANDS:
            a_entryObject.iconLabel = "clothing_hands";
            break;
         case skyui.defines.Armor.EQUIP_FOREARMS:
            a_entryObject.iconLabel = "clothing_forearms";
            break;
         case skyui.defines.Armor.EQUIP_FEET:
            a_entryObject.iconLabel = "clothing_feet";
            break;
         case skyui.defines.Armor.EQUIP_CALVES:
            a_entryObject.iconLabel = "clothing_calves";
            break;
         case skyui.defines.Armor.EQUIP_SHIELD:
            a_entryObject.iconLabel = "clothing_shield";
         case skyui.defines.Armor.EQUIP_EARS:
         default:
            return;
      }
   }
   function processBookIcon(a_entryObject)
   {
      a_entryObject.iconLabel = "default_book";
      switch(a_entryObject.subType)
      {
         case skyui.defines.Item.BOOK_RECIPE:
         case skyui.defines.Item.BOOK_NOTE:
            a_entryObject.iconLabel = "book_note";
            break;
         case skyui.defines.Item.BOOK_SPELLTOME:
            a_entryObject.iconLabel = "book_tome";
         default:
            return;
      }
   }
   function processWeaponIcon(a_entryObject)
   {
      a_entryObject.iconLabel = "default_weapon";
      a_entryObject.iconColor = 10790335;
      switch(a_entryObject.subType)
      {
         case skyui.defines.Weapon.TYPE_SWORD:
            a_entryObject.iconLabel = "weapon_sword";
            break;
         case skyui.defines.Weapon.TYPE_DAGGER:
            a_entryObject.iconLabel = "weapon_dagger";
            break;
         case skyui.defines.Weapon.TYPE_WARAXE:
            a_entryObject.iconLabel = "weapon_waraxe";
            break;
         case skyui.defines.Weapon.TYPE_MACE:
            a_entryObject.iconLabel = "weapon_mace";
            break;
         case skyui.defines.Weapon.TYPE_GREATSWORD:
            a_entryObject.iconLabel = "weapon_greatsword";
            break;
         case skyui.defines.Weapon.TYPE_BATTLEAXE:
            a_entryObject.iconLabel = "weapon_battleaxe";
            break;
         case skyui.defines.Weapon.TYPE_WARHAMMER:
            a_entryObject.iconLabel = "weapon_hammer";
            break;
         case skyui.defines.Weapon.TYPE_BOW:
            a_entryObject.iconLabel = "weapon_bow";
            break;
         case skyui.defines.Weapon.TYPE_STAFF:
            a_entryObject.iconLabel = "weapon_staff";
            break;
         case skyui.defines.Weapon.TYPE_CROSSBOW:
            a_entryObject.iconLabel = "weapon_crossbow";
            break;
         case skyui.defines.Weapon.TYPE_PICKAXE:
            a_entryObject.iconLabel = "weapon_pickaxe";
            break;
         case skyui.defines.Weapon.TYPE_FISHINGROD:
            a_entryObject.iconLabel = "weapon_fishingrod";
            break;
         case skyui.defines.Weapon.TYPE_WOODAXE:
            a_entryObject.iconLabel = "weapon_woodaxe";
         case skyui.defines.Weapon.TYPE_MELEE:
         default:
            return;
      }
   }
   function processAmmoIcon(a_entryObject)
   {
      a_entryObject.iconLabel = "weapon_arrow";
      a_entryObject.iconColor = 11050636;
      switch(a_entryObject.subType)
      {
         case skyui.defines.Weapon.AMMO_ARROW:
            a_entryObject.iconLabel = "weapon_arrow";
            break;
         case skyui.defines.Weapon.AMMO_BOLT:
            a_entryObject.iconLabel = "weapon_bolt";
         default:
            return;
      }
   }
   function processPotionIcon(a_entryObject)
   {
      a_entryObject.iconLabel = "default_potion";
      switch(a_entryObject.subType)
      {
         case skyui.defines.Item.POTION_DRINK:
            a_entryObject.iconLabel = "food_wine";
            break;
         case skyui.defines.Item.POTION_FOOD:
            a_entryObject.iconLabel = "default_food";
            break;
         case skyui.defines.Item.POTION_POISON:
            a_entryObject.iconLabel = "potion_poison";
            a_entryObject.iconColor = 11337907;
            break;
         case skyui.defines.Item.POTION_HEALTH:
         case skyui.defines.Item.POTION_HEALRATE:
         case skyui.defines.Item.POTION_HEALRATEMULT:
            a_entryObject.iconLabel = "potion_health";
            a_entryObject.iconColor = 14364275;
            break;
         case skyui.defines.Item.POTION_MAGICKA:
         case skyui.defines.Item.POTION_MAGICKARATE:
         case skyui.defines.Item.POTION_MAGICKARATEMULT:
            a_entryObject.iconLabel = "potion_magic";
            a_entryObject.iconColor = 3055579;
            break;
         case skyui.defines.Item.POTION_STAMINA:
         case skyui.defines.Item.POTION_STAMINARATE:
         case skyui.defines.Item.POTION_STAMINARATEMULT:
            a_entryObject.iconLabel = "potion_stam";
            a_entryObject.iconColor = 5364526;
            break;
         case skyui.defines.Item.POTION_FIRERESIST:
            a_entryObject.iconLabel = "potion_fire";
            a_entryObject.iconColor = 13055542;
            break;
         case skyui.defines.Item.POTION_ELECTRICRESIST:
            a_entryObject.iconLabel = "potion_shock";
            a_entryObject.iconColor = 15379200;
            break;
         case skyui.defines.Item.POTION_FROSTRESIST:
            a_entryObject.iconLabel = "potion_frost";
            a_entryObject.iconColor = 2096127;
         default:
            return;
      }
   }
   function processSoulGemIcon(a_entryObject)
   {
      a_entryObject.iconLabel = "misc_soulgem";
      a_entryObject.iconColor = 14934271;
      switch(a_entryObject.subType)
      {
         case skyui.defines.Item.SOULGEM_PETTY:
            a_entryObject.iconColor = 14144767;
            this.processSoulGemStatusIcon(a_entryObject);
            break;
         case skyui.defines.Item.SOULGEM_LESSER:
            a_entryObject.iconColor = 12630783;
            this.processSoulGemStatusIcon(a_entryObject);
            break;
         case skyui.defines.Item.SOULGEM_COMMON:
            a_entryObject.iconColor = 11248639;
            this.processSoulGemStatusIcon(a_entryObject);
            break;
         case skyui.defines.Item.SOULGEM_GREATER:
            a_entryObject.iconColor = 9735164;
            this.processGrandSoulGemIcon(a_entryObject);
            break;
         case skyui.defines.Item.SOULGEM_GRAND:
            a_entryObject.iconColor = 7694847;
            this.processGrandSoulGemIcon(a_entryObject);
            break;
         case skyui.defines.Item.SOULGEM_AZURA:
            a_entryObject.iconColor = 7694847;
            a_entryObject.iconLabel = "soulgem_azura";
         default:
            return;
      }
   }
   function processGrandSoulGemIcon(a_entryObject)
   {
      switch(a_entryObject.status)
      {
         case skyui.defines.Item.SOULGEMSTATUS_EMPTY:
            a_entryObject.iconLabel = "soulgem_grandempty";
            break;
         case skyui.defines.Item.SOULGEMSTATUS_FULL:
            a_entryObject.iconLabel = "soulgem_grandfull";
            break;
         case skyui.defines.Item.SOULGEMSTATUS_PARTIAL:
            a_entryObject.iconLabel = "soulgem_grandpartial";
         default:
            return;
      }
   }
   function processSoulGemStatusIcon(a_entryObject)
   {
      switch(a_entryObject.status)
      {
         case skyui.defines.Item.SOULGEMSTATUS_EMPTY:
            a_entryObject.iconLabel = "soulgem_empty";
            break;
         case skyui.defines.Item.SOULGEMSTATUS_FULL:
            a_entryObject.iconLabel = "soulgem_full";
            break;
         case skyui.defines.Item.SOULGEMSTATUS_PARTIAL:
            a_entryObject.iconLabel = "soulgem_partial";
         default:
            return;
      }
   }
   function processMiscIcon(a_entryObject)
   {
      a_entryObject.iconLabel = "default_misc";
      switch(a_entryObject.subType)
      {
         case skyui.defines.Item.MISC_ARTIFACT:
            a_entryObject.iconLabel = "misc_artifact";
            break;
         case skyui.defines.Item.MISC_GEM:
            a_entryObject.iconLabel = "misc_gem";
            a_entryObject.iconColor = 16756945;
            break;
         case skyui.defines.Item.MISC_HIDE:
            a_entryObject.iconLabel = "misc_hide";
            a_entryObject.iconColor = 14398318;
            break;
         case skyui.defines.Item.MISC_REMAINS:
            a_entryObject.iconLabel = "misc_remains";
            break;
         case skyui.defines.Item.MISC_INGOT:
            a_entryObject.iconLabel = "misc_ingot";
            a_entryObject.iconColor = 8553090;
            break;
         case skyui.defines.Item.MISC_CLUTTER:
            a_entryObject.iconLabel = "misc_clutter";
            break;
         case skyui.defines.Item.MISC_FIREWOOD:
            a_entryObject.iconLabel = "misc_wood";
            a_entryObject.iconColor = 11050636;
            break;
         case skyui.defines.Item.MISC_DRAGONCLAW:
            a_entryObject.iconLabel = "misc_dragonclaw";
            break;
         case skyui.defines.Item.MISC_LOCKPICK:
            a_entryObject.iconLabel = "misc_lockpick";
            break;
         case skyui.defines.Item.MISC_GOLD:
            a_entryObject.iconLabel = "misc_gold";
            a_entryObject.iconColor = 13421619;
            break;
         case skyui.defines.Item.MISC_LEATHER:
            a_entryObject.iconLabel = "misc_leather";
            a_entryObject.iconColor = 12225827;
            break;
         case skyui.defines.Item.MISC_LEATHERSTRIPS:
            a_entryObject.iconLabel = "misc_strips";
            a_entryObject.iconColor = 12225827;
            break;
         case skyui.defines.Item.MISC_TROLLSKULL:
            a_entryObject.iconLabel = "misc_trollskull";
            break;
         case skyui.defines.Item.MISC_CHILDRENSCLOTHES:
            a_entryObject.iconColor = 15587975;
            a_entryObject.iconLabel = "clothing_body";
         default:
            return;
      }
   }
   function processMiscBaseIdIcon(a_entryObject)
   {
      switch(a_entryObject.baseId)
      {
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
            a_entryObject.iconLabel = "misc_ore";
            a_entryObject.iconColor = 8553090;
            break;
         case 0x60CC2:
         case 0xBBCD5:
         case 0x2BAAE:
         case 0x80D:
         case 0xE29A:
            a_entryObject.iconLabel = "book_map";
            break;
         case 0x1CD7C:
            a_entryObject.iconLabel = "misc_strips";
            a_entryObject.iconColor = 7886222;
            break;
         case 0x3AD57:
         case 0x195AA:
         case 0x2B04E:
            a_entryObject.iconLabel = "misc_chitin";
            a_entryObject.iconColor = 9141338;
            break;
         case 0x17719:
         case 0x1771F:
            a_entryObject.iconLabel = "scroll_spider";
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
            a_entryObject.iconLabel = "misc_housepart";
            a_entryObject.iconColor = 16777215;
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
            a_entryObject.iconLabel = "default_weapon";
            a_entryObject.iconColor = 16777215;
            break;
         case 0x809:
         case 0x762B7:
         case 0x762B8:
         case 0x762B9:
         case 0x762BA:
         case 0xBDB37:
            a_entryObject.iconLabel = "soulgem_ayleidcrystalfull";
            a_entryObject.iconColor = 6014153;
            break;
         case 0x30C9:
         case 0x30CA:
         case 0x723B8:
            a_entryObject.iconLabel = "misc_horsetack";
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
            a_entryObject.iconLabel = "misc_dwarvenscrap";
            a_entryObject.iconColor = 7364402;
            break;
         case 0x28AD7:
            a_entryObject.iconLabel = "soulgem_azura";
            break;
         case 0x2C259:
         case 0x2C25A:
         case 0xC4F2E:
         case 0x82F:
            a_entryObject.iconLabel = "default_potion";
            break;
         case 0x2BAAB:
            a_entryObject.iconLabel = "potion_poison";
            break;
         case 0x457AB:
         case 0xDC530:
         case 0xDC52E:
         case 0x13201:
         case 0x13202:
            a_entryObject.iconLabel = "default_scroll";
            break;
         case 0xF1491:
         case 0xCE70B:
         case 0xE4897:
         case 0xE3CB7:
            a_entryObject.iconLabel = "default_book";
            break;
         case 0x1CB34:
         case 0xDA732:
         case 0xDA733:
         case 0xDA734:
         case 0xDA735:
            a_entryObject.iconLabel = "armor_ring";
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
            a_entryObject.iconLabel = "default_ingredient";
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
            a_entryObject.iconLabel = "misc_instrument";
            a_entryObject.iconColor = 16777215;
            break;
         case 0xB08C7:
         case 0xFBC3A:
         case 0xFBC3B:
         case 0xFBC3C:
         case 0xFBC3D:
         case 0x12DD3A:
         case 0x12DD3B:
         case 0x12DD3C:
            a_entryObject.iconLabel = "misc_jar";
            a_entryObject.iconColor = 16777215;
            break;
      }
   }
   function processBookBaseIdIcon(a_entryObject)
   {
      switch(a_entryObject.baseId)
      {
         case 0xDDEFB:
         case 0xEF07A:
         case 0xF33CD:
         case 0xF33CE:
         case 0xF33CF:
         case 0xF33D0:
         case 0xF33D1:
         case 0xF33D2:
         case 0xF33D3:
         case 0xF33D4:
         case 0xF33D5:
         case 0xF33E0:
         case 0x1CAF2:
         case 0x70CCA:
         case 0x70CCB:
         case 0x70CCC:
         case 0x70CCD:
         case 0x70CCE:
         case 0x70CCF:
         case 0x70CD0:
         case 0x70CD1:
         case 0x70CD2:
         case 0x70CD3:
         case 0x70CD4:
         case 0x70CD5:
            a_entryObject.iconLabel = "book_map";
            break;
         case 0x2D513:
         case 0x48782:
         case 0x126DC:
         case 0x11A13:
         case 0x118F9:
            a_entryObject.iconLabel = "misc_elderscroll";
            a_entryObject.iconColor = 7693901;
            break;
      }
   }
   function processScrollBaseIdIcon(a_entryObject)
   {
      switch(a_entryObject.baseId)
      {
         case 0x1445E:
         case 0x14480:
         case 0x16E1C:
         case 0x1707B:
         case 0x1952C:
         case 0x19534:
         case 0x1CAB0:
         case 0x1DA03:
         case 0x206D3:
         case 0x206D9:
         case 0x206DB:
         case 0x2095F:
         case 0x20960:
         case 0x20961:
         case 0x27490:
         case 0x2749D:
         case 0x274A5:
         case 0x3319E:
         case 0x3319F:
         case 0x331A0:
         case 0x331A1:
            a_entryObject.iconLabel = "scroll_spider";
            break;
      }
   }
   function processPotionBaseIdIcon(a_entryObject)
   {
      switch(a_entryObject.baseId)
      {
         case 0x20E802:
         case 0xAF476:
         case 0xAF477:
            a_entryObject.iconLabel = "soulgem_ayleidcrystalfull";
            a_entryObject.iconColor = 6014153;
            break;
      }
   }
   function processSoulGemBaseIdIcon(a_entryObject)
   {
      if(a_entryObject.baseId == 0x804 || a_entryObject.baseId == 0x137F40)
      {
         a_entryObject.iconColor = 13716024;
         switch(a_entryObject.status)
         {
            case skyui.defines.Item.SOULGEMSTATUS_EMPTY:
               a_entryObject.iconLabel = "soulgem_tomatoempty";
               break;
            case skyui.defines.Item.SOULGEMSTATUS_PARTIAL:
               a_entryObject.iconLabel = "soulgem_tomatopartial";
               break;
            case skyui.defines.Item.SOULGEMSTATUS_FULL:
               a_entryObject.iconLabel = "soulgem_tomatofull";
               break;
         }
      }
   }
}
