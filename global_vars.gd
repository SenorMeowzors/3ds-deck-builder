extends Node

var opa = 1
var sens = 1
var deck = Array()
var score = 0
var first = true
var isPaused = false

func addScore(points):
	score += points

func saveDeck(Deck):
	deck = Deck
