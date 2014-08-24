PHYSICS_CATEGORY_SHOT =          0x0001
PHYSICS_CATEGORY_VEHICLE =       0x0002
PHYSICS_CATEGORY_ENEMY =         0x0004
PHYSICS_CATEGORY_DESTROYABLE =   0x0008
PHYSICS_CATEGORY_UNDESTROYABLE = 0x0010

PHYSICS_MASK_SHOT =          0x001c --PHYSICS_CATEGORY_ENEMY | PHYSICS_CATEGORY_DESTROYABLE | PHYSICS_CATEGORY_UNDESTROYABLE
PHYSICS_MASK_VEHICLE =       0x001c --PHYSICS_CATEGORY_ENEMY | PHYSICS_CATEGORY_DESTROYABLE | PHYSICS_CATEGORY_UNDESTROYABLE
PHYSICS_MASK_ENEMY =         0x001f --PHYSICS_CATEGORY_ENEMY | PHYSICS_CATEGORY_DESTROYABLE | PHYSICS_CATEGORY_UNDESTROYABLE | PHYSICS_CATEGORY_VEHICLE | PHYSICS_CATEGORY_SHOT
PHYSICS_MASK_DESTROYABLE =   0x001f --PHYSICS_CATEGORY_ENEMY | PHYSICS_CATEGORY_DESTROYABLE | PHYSICS_CATEGORY_UNDESTROYABLE | PHYSICS_CATEGORY_VEHICLE | PHYSICS_CATEGORY_SHOT
PHYSICS_MASK_UNDESTROYABLE = 0x001f --PHYSICS_CATEGORY_ENEMY | PHYSICS_CATEGORY_DESTROYABLE | PHYSICS_CATEGORY_UNDESTROYABLE | PHYSICS_CATEGORY_VEHICLE | PHYSICS_CATEGORY_SHOT

PHYSICS_GROUP_SHOT =          -4
PHYSICS_GROUP_VEHICLE =       -4
PHYSICS_GROUP_ENEMY =         1
PHYSICS_GROUP_DESTROYABLE =   2
PHYSICS_GROUP_UNDESTROYABLE = 3