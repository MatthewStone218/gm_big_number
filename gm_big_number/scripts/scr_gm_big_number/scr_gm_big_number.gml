// v2.3.0에 대한 스크립트 어셋 변경됨 자세한 정보는
// https://help.yoyogames.com/hc/en-us/articles/360005277377 참조
function number(num){
	return new __number_class_element__(num);
}

function __number_class_element__(num) constructor{
	if(is_real(num)){
		var _num_fract = int64(0);
		var _frac = frac(abs(num));
		for(var i = 1; i < 62+1; i++){
			if(sign(_frac) == 1 && power(0.5,i) <= _frac){
				_frac -= power(0.5,i);
				_num_fract += 1;
			}
			_num_fract = _num_fract << 1;
		}
		
		self.num_sign = sign(num);
		self.num = [_num_fract, int64(abs(num))];
	} else {
		self.num = [int64(0),int64(0)];
		var _sign = string_char_at(num,1);
		if(_sign == "+"){
			self.num_sign = 1;
			num = string_copy(num,2,string_length(num)-1);
		} else if(_sign == "-"){
			self.num_sign = -1;
			num = string_copy(num,2,string_length(num)-1);
		} else {
			self.num_sign = 1;
		}
		
		var _str_int;
		var _str_fract;
		var _dot_pos = string_pos(".",num);
		
		if(_dot_pos != 0){
			_str_int = string_copy(num,1,_dot_pos-1);
			_str_fract = "0."+string_copy(num,_dot_pos+1,string_length(num)-_dot_pos);
		} else {
			_str_int = num;
			_str_fract = "0";
		}
		
		var _is_not_zero = false;
		for(var i = (string_length(_str_int)-1) div 9; i >= 0; i--){
			var _str = string_copy(_str_int,max(string_length(_str_int)-((i+1)*9),0)+1,min(9,string_length(_str_int)-((i+1)*9)+9));
			var _real = real(_str);
			if(_real != 0){
				_is_not_zero = true;
			}
			if(_real == 0 && _is_not_zero){
				_real = 1000000000;
			}
			var _sum_num = __number_sum__(self,__number_multiply__(number(_real),__number_power_real__(number(1000000000),i)));
			//show_debug_message($"***********\n{number_string(number(_real))}\n{number_string(__number_power_real__(number(1000000000),i))}\n{number_string(_sum_num)}");
			self.num = _sum_num.num;
		}
		
		var _num_fract = int64(0);
		var _frac = frac(abs(real(_str_fract)));
		for(var i = 1; i < 62+1; i++){
			if(sign(_frac) == 1 && power(0.5,i) <= _frac){
				_frac -= power(0.5,i);
				_num_fract += int64(1);
			}
			_num_fract = _num_fract << 1;
		}
		self.num[0] = _num_fract;
	}
}

function number_string(numb){
	var _str = "";
	if(numb.num_sign == -1){_str += "-"}
	for(var i = 0; i < array_length(numb.num); i++){
		_str += "|";
		for(var ii = 62; ii >= 0; ii--){
			_str += string((numb.num[i] & (int64(1) << ii)) != 0);
		}
	}
	return _str;
}

function number_sum(a,b){
	if(a.num_sign != -1 && b.num_sign != -1){
		return __number_sum__(a,b);
	} else {
		return __number_sub__(a,b);
	}
}

function number_sub(a,b){
	return __number_sub__(a,b);
}

function number_multiply(a,b){
	return __number_multiply__(a,b);
}

function number_div(a,b){
	if(array_length(b.num) == 2 && b.num[1] == 0){
		show_error("big number: can't divide with 0",1);
	}
	if(array_length(a.num) == 2 && b.num[1] == 0){
		return number(0);
	}
	return __number_multiply__(a,__number_reciprocal__(b));
}

function number_cmp(a,b){
	if(a.num_sign > b.num_sign){
		return 1;
	} else if(a.num_sign < b.num_sign){
		return -1;
	}
	if(array_length(a.num) > array_length(b.num)){
		return 1;
	} else if(array_length(a.num) < array_length(b.num)){
		return -1;
	}
	for(var i = array_length(a.num)-1; i >= 0; i--){
		for(var ii = 63-1; ii >= 0; ii--){
			var _bit_a = ((a.num[i] & (int64(1) << ii)) != 0);
			var _bit_b = ((b.num[i] & (int64(1) << ii)) != 0);
			if(_bit_a > _bit_b){
				return 1;
			} else if(_bit_a < _bit_b){
				return -1;
			}
		}
	}
	return 0;
}

function number_abs(numb){
	var _new_numb = number(0);
	_new_numb.num_sign = (numb.num_sign == -1) || (numb.num_sign == 1);
	array_copy(_new_numb.num,0,numb.num,0,array_length(numb.num));
	return _new_numb;
}

function __number_power_real__(numb1,pow){
	var _new_numb = number(1);
	var _pow_numb = number(0);
	_pow_numb.num = variable_clone(numb1.num);
	_pow_numb.num_sign = numb1.num_sign;
	repeat(pow){
		_new_numb = __number_multiply__(_new_numb,_pow_numb);
	}
	return _new_numb;
}

function __number_multiply__(numb1,numb2){
	var _new_numb = number(0);
	_new_numb.num_sign = numb1.num_sign*numb2.num_sign;
	for(var i = 0; i < array_length(numb2.num); i++){
		for(var ii = 0; ii < array_length(numb1.num); ii++){
			for(var iii = 0; iii < 63; iii++){
				if((numb2.num[i] & (int64(1) << iii)) != 0){
					var _shift = 63*i+iii-63;//show_message($"63*{i}+{iii}-63 = {_shift}")
					var _temp_num = number(0);
					_temp_num.num_sign = 1;
					for(var iiii = 0; iiii < _shift div 63; iiii++){
						_temp_num.num[iiii] = 0;
					}
					var _shift_left;
					if(_shift >= 0){
						_shift_left = _shift mod 63;
					} else {
						_shift_left = -((-_shift) mod 63);
					}
					var _index = ii + ((_shift >= 0) ? (_shift div 63) : -(-_shift div 63));
					if(_index >= 0){
						_temp_num.num[_index] = (_shift_left >= 0) ? (numb1.num[ii] << _shift_left) : (numb1.num[ii] >> -_shift_left);
						_temp_num.num[_index] = _temp_num.num[_index] & 0b0111111111111111111111111111111111111111111111111111111111111111;
						//show_message($"{numb1.num[ii]} {(_shift_left >= 0)} {(numb1.num[ii] << _shift_left)}")
					}
					var _shift_right;
					if(_shift >= 0){
						_shift_right = 63-(_shift mod 63);
					} else {
						_shift_right = -(63-((-_shift) mod 63));
					}
					var _index = ii + (((_shift >= 0) ? (_shift div 63) : -(-_shift div 63))) + sign(_shift);
					if(_shift != 0 && _index >= 0){
						var _temp = (_shift_right >= 0) ? (numb1.num[ii] >> _shift_right) : (numb1.num[ii] << -_shift_right);
						if(_temp != 0){
							_temp_num.num[_index] = _temp;
							_temp_num.num[_index] = _temp_num.num[_index] & 0b0111111111111111111111111111111111111111111111111111111111111111;
						}
					}
					_new_numb = __number_sum__(_new_numb,_temp_num);
				}
			}
		}
	}
	for(var i = array_length(_new_numb.num)-1; i >= 0;i--){
		if(_new_numb.num[i] == 0){
			array_delete(_new_numb.num,i,1);
		} else {
			break;
		}
	}
	return _new_numb;
}

function __number_reciprocal__(numb){
	var _new_numb = number(0);
	
	var _blank = true;
	for(var i = 0; i < array_length(numb.num); i++){
		if(numb.num[i] != 0){
			_blank = false;
			break;
		}
	}
	if(_blank){
		show_error("big number: can't reciprocal 0",true);
	}
	
	_new_numb.num_sign = numb.num_sign;
	
	if(array_length(numb.num) >= 3){
		_new_numb.num = [int64(0),int64(0)];
		_new_numb.num_sign = 0;
		return _new_numb;
	}
	
	var _break = false;
	for(var _a = 1; _a >= 0; _a++){
		for(var _b = 62; _b >= 0; _b--){
			if((numb.num[_a] & (int64(1) << _b)) != 0){
				_break = true;
				break;
			}
		}
		if(_break){
			break;
		}
	}
	
	var _init_value_shift = -_b*(_a*2 - 1);
	var _numb_result = number(0);
	_numb_result.num_sign = 1;
	if(_init_value_shift >= 0){
		_numb_result.num = [int64(1) << _init_value_shift]//0
		//오버플로우
	} else {
		_numb_result.num = [int64(1) >> _init_value_shift]//0
		//오버플로우
	}

	var _numb_original = number(0);
	_numb_original.num = variable_clone(numb).num;
	_numb_original.num_sign = 1;
	
	var _n2 = number(2);
	for(var i = 0; i < 7; i++){
		var _result = __number_multiply__(_numb_result,__number_sub__(_n2,__number_multiply__(_numb_original,_numb_result)));
		_numb_result = _result;
	}
	
	return _new_numb;
}

function __number_sum__(numb1,numb2){
	var _new_numb = number(0);
	_new_numb.num_sign = numb1.num_sign;

	var _base_num = variable_clone(numb1.num);
	var _sum_num = variable_clone(numb2.num);
	
	for(var i = array_length(_sum_num); i < array_length(_base_num); i++){
		_sum_num[i] = 0;
	}
	for(var i = array_length(_base_num); i < array_length(_sum_num); i++){
		_base_num[i] = 0;
	}
	var _overed = false;
	for(var i = 0; i < array_length(_base_num); i++){
		var _temp_over;
		var _overed2 = false;
		while(_sum_num[i] != 0){
			_temp_over = _base_num[i] & _sum_num[i];//show_message($"1234\n{i}\n{_base_num[i]}\n{_sum_num[i]}")
			_base_num[i] = _base_num[i] ^ _sum_num[i];
			_sum_num[i] = _temp_over << 1;
			_sum_num[i] = _sum_num[i] & 0b0111111111111111111111111111111111111111111111111111111111111111;
			_overed2 = _overed2 || (_temp_over & (int64(1) << 62) != 0);
			//if(_overed2)show_message($"{_temp_over}")
		}
		if(_overed){
			_sum_num[i] = int64(1);
			while(_sum_num[i] != 0){
				_temp_over = _base_num[i] & _sum_num[i];
				_base_num[i] = _base_num[i] ^ _sum_num[i];//show_message($"asfd\n{i}\n{_base_num[i]}\n{_sum_num[i]}")
				_sum_num[i] = _temp_over << 1;
				_sum_num[i] = _sum_num[i] & 0b0111111111111111111111111111111111111111111111111111111111111111;
				_overed2 = _overed2 || ((_temp_over & (int64(1) << 62)) != 0);
			}
		}
		_overed = _overed2;
		if(_overed2 && array_length(_base_num)-1 < i+1){
			_base_num[i+1] = 0;
			_sum_num[i+1] = 0;
		}
	}
	_new_numb.num = variable_clone(_base_num);
	return _new_numb;
}

function __number_sub__(numb1,numb2){
	var _new_numb = number(0);
	_new_numb.num_sign = number_cmp(numb1,numb2);
	
	var _abs_cmp = number_cmp(number_abs(numb1),number_abs(numb2));
	if(_abs_cmp == -1){
		var _base_num = variable_clone(numb2.num);
		var _sub_num = variable_clone(numb1.num);
	} else {
		var _base_num = variable_clone(numb1.num);
		var _sub_num = variable_clone(numb2.num);
	}
	
	for(var i = array_length(_sub_num); i < array_length(_base_num); i++){
		_sub_num[i] = 0;
	}
	for(var i = array_length(_base_num); i < array_length(_sub_num); i++){
		_base_num[i] = 0;
	}
	
	var _overed = false;
	for(var i = 0; i < array_length(_base_num); i++){
		var _temp_over;
		var _overed2 = false;
		while(_sub_num[i] != 0){
			_temp_over = (~_base_num[i]) & _sub_num[i];
			_base_num[i] = _base_num[i] ^ _sub_num[i];
			_sub_num[i] = _temp_over << 1;
			_sub_num[i] = _sub_num[i] & 0b0111111111111111111111111111111111111111111111111111111111111111;
			_overed2 = _overed2 || ((_temp_over & (int64(1) << 62)) != 0);
		}
		if(_overed){
			_sub_num[i] = int64(1) << 62;
			_temp_over = (~_base_num[i]) & _sub_num[i];
			_base_num[i] = _base_num[i] ^ _sub_num[i];
			_sub_num[i] = _temp_over << 1;
			_sub_num[i] = _sub_num[i] & 0b0111111111111111111111111111111111111111111111111111111111111111;
			_overed2 = _overed2 || ((_temp_over & (int64(1) << 62)) != 0);
		}
		_overed = _overed2;
	}
	for(var i = array_length(_base_num)-1; i >= 2; i--){
		if(_base_num[i] == 0){
			array_delete(_base_num,i,1);
		}
	}
	_new_numb.num = variable_clone(_base_num);
	return _new_numb;
}