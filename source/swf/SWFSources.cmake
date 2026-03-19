# ActionScript sources for all SWFs
# This file consolidates the source lists for each SWF.

# Common sources used by many menus
set(CORE_SOURCES
    ${AS_SOURCE_DIR}/Common/skyui/defines/Actor.as
    ${AS_SOURCE_DIR}/Common/skyui/defines/Armor.as
    ${AS_SOURCE_DIR}/Common/skyui/defines/Form.as
    ${AS_SOURCE_DIR}/Common/skyui/defines/Input.as
    ${AS_SOURCE_DIR}/Common/skyui/defines/Inventory.as
    ${AS_SOURCE_DIR}/Common/skyui/defines/Item.as
    ${AS_SOURCE_DIR}/Common/skyui/defines/Magic.as
    ${AS_SOURCE_DIR}/Common/skyui/defines/Material.as
    ${AS_SOURCE_DIR}/Common/skyui/defines/Weapon.as
    ${AS_SOURCE_DIR}/Common/skyui/filter/ItemTypeFilter.as
    ${AS_SOURCE_DIR}/Common/skyui/filter/NameFilter.as
    ${AS_SOURCE_DIR}/Common/skyui/filter/SortFilter.as
)

set(ITEM_MENU_CORE
    ${CORE_SOURCES}
    ${AS_SOURCE_DIR}/ItemMenus/InventoryDataSetter.as
    ${AS_SOURCE_DIR}/ItemMenus/InventoryIconSetter.as
    ${AS_SOURCE_DIR}/ItemMenus/ItemMenu.as
    ${AS_SOURCE_DIR}/ItemMenus/ItemcardDataExtender.as
)

# Individual SWF sources
set(bartermenu_SOURCES
    ${ITEM_MENU_CORE}
    ${AS_SOURCE_DIR}/ItemMenus/BarterMenu.as
    ${AS_SOURCE_DIR}/ItemMenus/BarterDataSetter.as
)

set(containermenu_SOURCES
    ${ITEM_MENU_CORE}
    ${AS_SOURCE_DIR}/ItemMenus/ContainerMenu.as
)

set(inventorymenu_SOURCES
    ${ITEM_MENU_CORE}
    ${AS_SOURCE_DIR}/ItemMenus/InventoryMenu.as
)

set(magicmenu_SOURCES
    ${ITEM_MENU_CORE}
    ${AS_SOURCE_DIR}/ItemMenus/MagicMenu.as
)

set(giftmenu_SOURCES
    ${ITEM_MENU_CORE}
    ${AS_SOURCE_DIR}/ItemMenus/GiftMenu.as
)

set(craftingmenu_SOURCES
    ${CORE_SOURCES}
    ${AS_SOURCE_DIR}/CraftingMenu/CraftingMenu.as
    ${AS_SOURCE_DIR}/CraftingMenu/CraftingDataSetter.as
    ${AS_SOURCE_DIR}/CraftingMenu/CraftingIconSetter.as
    ${AS_SOURCE_DIR}/CraftingMenu/CraftingListEntry.as
    ${AS_SOURCE_DIR}/CraftingMenu/CraftingLists.as
    ${AS_SOURCE_DIR}/CraftingMenu/CustomConstructDataSetter.as
    ${AS_SOURCE_DIR}/CraftingMenu/IconTabList.as
    ${AS_SOURCE_DIR}/CraftingMenu/IconTabListEntry.as
)

set(favoritesmenu_SOURCES
    ${CORE_SOURCES}
    ${AS_SOURCE_DIR}/FavoritesMenu/FavoritesMenu.as
    ${AS_SOURCE_DIR}/FavoritesMenu/FavoritesIconSetter.as
    ${AS_SOURCE_DIR}/FavoritesMenu/FavoritesListEntry.as
)

set(quest_journal_SOURCES
    ${CORE_SOURCES}
    ${AS_SOURCE_DIR}/QuestJournal/QuestJournal.as
)

set(map_SOURCES
    ${CORE_SOURCES}
    ${AS_SOURCE_DIR}/MapMenu/MapMenu.as
)

set(modmanager_SOURCES
    ${AS_SOURCE_DIR}/ModConfigPanel/ModConfigPanel.as
)

# For all other SWFs that might not have custom sources defined here yet,
# we can add them as needed. The build system will look for <SWF_NAME_WE>_SOURCES.
