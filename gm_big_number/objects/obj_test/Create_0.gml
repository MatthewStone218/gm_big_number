/// @description 여기에 설명 삽입
// 이 에디터에 코드를 작성할 수 있습니다
//show_message(number_sum(number(3.5),number(4.70)));

num1 = number(0b000000000000000000000000000000000000000000000000000000000000010);
num2 = number(0b000000000000000000000000000000000000000000000000000000000000110);
show_debug_message(number_string(__number_reciprocal__(number_sum(num1,num2))))
show_debug_message(number_string(number_div(num1,num2)));
//show_debug_message($"{num1}\n{number_string(num1)}\n{number_string(num2)}\n{number_string(number_sub(num1,num2))}")
show_debug_message($"{num1}\n{number_string(num1)}\n{number_string(num2)}\n{number_string(__number_reciprocal__(num1))}\n{number_string(__number_reciprocal__(num2))}")