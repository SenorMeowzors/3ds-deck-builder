extends Node

var opa = 1
var sens = 1
var Atkdeck = Array()
var Specdeck = Array()
var score = 0
var first = true

func addScore(points):
	score += points

func saveAtkDeck(Deck):
	Atkdeck = Deck

func saveSpecDeck(Deck):
	Specdeck = Deck
