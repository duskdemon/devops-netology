package main

import "fmt"

func main() {
fmt.Print("numbers from 1 to 100 are able to divide by 3 are: ")
	for i := 1; i < 100; i++ {
		if i%3 == 0 {	
		fmt.Print(i,", ")
		}
	}
}