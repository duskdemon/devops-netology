#devops-netology
### 07-terraform-05-golang
# Домашнее задание к занятию "7.5. Основы golang"

С `golang` в рамках курса, мы будем работать не много, поэтому можно использовать любой IDE. 
Но рекомендуем ознакомиться с [GoLand](https://www.jetbrains.com/ru-ru/go/).  

## Задача 1. Установите golang.
1. Воспользуйтесь инструкций с официального сайта: [https://golang.org/](https://golang.org/).
2. Так же для тестирования кода можно использовать песочницу: [https://play.golang.org/](https://play.golang.org/).  
**Ответ:**  
Установил go1.17.5.windows-amd64  

## Задача 2. Знакомство с gotour.
У Golang есть обучающая интерактивная консоль [https://tour.golang.org/](https://tour.golang.org/). 
Рекомендуется изучить максимальное количество примеров. В консоли уже написан необходимый код, 
осталось только с ним ознакомиться и поэкспериментировать как написано в инструкции в левой части экрана.  

**Ответ:**  
Посмотрел примеры.  

## Задача 3. Написание кода. 
Цель этого задания закрепить знания о базовом синтаксисе языка. Можно использовать редактор кода 
на своем компьютере, либо использовать песочницу: [https://play.golang.org/](https://play.golang.org/).

1. Напишите программу для перевода метров в футы (1 фут = 0.3048 метр). Можно запросить исходные данные 
у пользователя, а можно статически задать в коде.
    Для взаимодействия с пользователем можно использовать функцию `Scanf`:
    ```
    package main
    
    import "fmt"
    
    func main() {
        fmt.Print("Enter a number: ")
        var input float64
        fmt.Scanf("%f", &input)
    
        output := input * 2
    
        fmt.Println(output)    
    }
    ```
 **Ответ:**  
```
package main

import (
	"fmt"
	//"math"
)

func main() {
	fmt.Print("length, in feet: ")
	var input float64
	fmt.Scanf("%f", &input)
	output := input * float64(0.3048)
//	routput := math.Round(output)
	foutput := fmt.Sprintf("%.2f", output)
	fmt.Println("lenght in Meters:", foutput)
}
```
вывод программы:  
```
C:\Program Files\Go\bin>go run G:\PortableGit\devops-netology\m-to-f.go
Enter length, in feet: 1
Lenght in Meters: 0.30
```

1. Напишите программу, которая найдет наименьший элемент в любом заданном списке, например:
    ```
    x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}
    ```
 **Ответ:**  
```
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
```
вывод программы:  
```
C:\Program Files\Go\bin>go run G:\PortableGit\devops-netology\min.go
finding minimum number from array [49 82 40 15 -34 29 23 -33 47 47 38 15]
Minimum number from array is: -34
```
    
1. Напишите программу, которая выводит числа от 1 до 100, которые делятся на 3. То есть `(3, 6, 9, …)`.

 **Ответ:**  
```
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
```
вывод программы:  
```
C:\Program Files\Go\bin>go run G:\PortableGit\devops-netology\div3.go
numbers from 1 to 100 are able to divide by 3 are: 3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36, 39, 42, 45, 48, 51, 54, 57, 60, 63, 66, 69, 72, 75, 78, 81, 84, 87, 90, 93, 96, 99,
```
