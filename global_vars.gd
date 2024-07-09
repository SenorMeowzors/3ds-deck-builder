extends Node

var opa = 1
var sens = 1
var deck = Array()
var score = 0

func addScore(points):
	score += points

func getScore():
	return score

func saveDeck(Deck):
	deck = Deck

func getDeck():
	return deck
