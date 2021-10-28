extends Sprite
class_name muge_charMover

export var canMove: bool = false
export var moveSpeed: float = 0
export var startPosition: float = 0
export var twoLines: bool = false
export var endPosition: float = 0
export var ySpaceBetween: float = 40
var onLineTwo: bool = false

func _process(delta):
    if canMove:
        self.position = self.position + Vector2(moveSpeed*delta,0)
        if self.position.x > endPosition:
            if not twoLines:
                canMove = false
            else:
                if not onLineTwo:
                    onLineTwo = true
                    self.position = Vector2(startPosition,self.position.y + ySpaceBetween)
                else:
                    canMove = false