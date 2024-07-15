variable "fruit" {
  type = string
  description = "variable name has a fruit value"
  default = "apple"
}
variable "fruits" {
  type = list(string)
  default = ["apple","banana"]
}
variable "fruit_price" {
  type = map(string)
  default = {
    apple = 100
    banana = 20
  }
}

output "fruit_name" {
  value = var.fruit
}
output "first_fruit" {
  value = var.fruits[0]
}
output "first_fruit_price" {
  value = "the price of ${var.fruits[0]} is ${var.fruit_price["apple"]}"
}
output "second_fruit_price"{
  value = "the price of ${var.fruits[1]} is ${var.fruit_price["banana"]}"
}