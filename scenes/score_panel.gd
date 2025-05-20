extends CanvasLayer

var score: int = 0

func increment_score(increment_by: int = 1):
	self.score += increment_by
	self.get_node("Label").text = "SCORE: " + str(self.score)

func reset_score():
	self.score = 0
	self.get_node("Label").text = "SCORE: " + str(self.score)
