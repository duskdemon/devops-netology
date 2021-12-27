package main

import (
		"fmt"
		//"math"
)

var number int = 1000

func main() {
	x := []int{49,82,40,15,-34,29,23,-33,47,47,38,15}
	fmt.Println ("finding minimum number from array", x)
	for i := range x {
		i = x[i]
				if (i < number){
			number = i
		}
	}

	fmt.Println("Minimum number from array is:", number)
} 