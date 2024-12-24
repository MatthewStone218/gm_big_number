// v2.3.0에 대한 스크립트 어셋 변경됨 자세한 정보는
// https://help.yoyogames.com/hc/en-us/articles/360005277377 참조
function number(num){
	return new __number_class_element__(num);
}

function __number_class_element__(num) constructor{
	if(is_real(num)){
		var _num_fract = 0;
		var _frac = frac(abs(num));
		for(var i = 1; i < 64+1; i++){
			if(power(0.5,i) < _frac){
				_num_fract = _num_fract << 1;
				_frac -= power(0.5,i);
				_num_fract += 1;
			}
		}
		num = int64(num);
		self.num_sign = sign(num);
		self.num = [_num_fract, abs(num)];
	} else {
		show_error("defining number with string is not yet implemented!",1);
	}
}

function number_string(numb){
	var _str = "";
	for(var i = 0; i < array_length(numb); i++){
		
	}
}

function number_sum(a,b){
	if(a.sign != -1 && b.sign != -1){
		return __number_sum__(a,b);
	} else if(a.sign == -1 xor b.sign == -1){
		var _abs_cmp = number_cmp(number_abs(a),number_abs(b));
		if(_abs_cmp == -1){
			var _temp = a;
			a = b;
			b = _temp;
		}
		return __number_sub__(a,b);
	} else {
		return __number_sum__(a,b);
	}
}

function number_div(a,b){
	if(array_length(b.num) == 2 && b.num[1] == 0){
		show_error("big number: can't divide with 0",1);
	}
	if(array_length(a.num) == 2 && b.num[1] == 0){
		return number(0);
	}
	return __number_div__(a,b);
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
		for(var ii = 63; ii >= 0; ii--){
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

function __number_div__(numb1,numb2){
	var _new_numb = number(0);
	_new_numb.num_sign = numb1.num_sign*numb2.num_sign;
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
			_temp_over = _base_num[i] & _sum_num[i];
			_base_num[i] = _base_num[i] xor _sum_num[i];
			_sum_num[i] = _temp_over << 1;
			
			_overed2 = _overed2 || _temp_over >> 63;
		}
		if(_overed){
			_sum_num[i] = 1;
			while(_sum_num[i] != 0){
				_temp_over = _base_num[i] & _sum_num[i];
				_base_num[i] = _base_num[i] xor _sum_num[i];
				_sum_num[i] = _temp_over << 1;
			
				_overed2 = _overed2 || _temp_over >> 63;
			}
		}
		_overed = _overed2;
		if(_overed2 && array_length(_base_num)-1 < i+1){
			_base_num[i+1] = 0;
			_sum_num[i+1] = 0;
		}
	}
	
	_new_numb.num = _base_num.num;
	return _new_numb;
}