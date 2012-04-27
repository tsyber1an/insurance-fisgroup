<?xml version="1.0" encoding="UTF-8"?>

<!DOCTYPE stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text>&#160;</xsl:text>">
	<!ENTITY and "&amp;&amp;">
]>


<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				exclude-result-prefixes="xsl exsl"
				xmlns:exsl="http://exslt.org/common"
				extension-element-prefixes="exsl">

<!-- CONFIGS -->


<!-- end CONFIG -->

<xsl:template match='/'>

	<html>
		<head>
			<meta http-equiv="content-type" content="text/html; charset=utf-8"/>
			<xsl:call-template name='css'/>
			<xsl:call-template name='javascript'/>
		</head>
		<body>
			<!-- variables here -->
			<xsl:call-template name='body'/>
		</body>
	</html>
</xsl:template>

<xsl:template name="css">
	<link rel="stylesheet" href="jquery-ui.custom.css"/>
	<style type="text/css">
		* { margin: 0; padding: 0; }
		body { }
		a { text-decoration: none; color: #459FED; }
		a:hover { text-decoration: underline; }
		a:active, a:visited { color: #459FED; }
		img { border: 0; }
		ul { list-style: none; }
		ul li { margin-bottom:20px; }
		h4 { color: #91979C; font-weight: 600; margin-bottom: 4px; }
		h5 { color: #95999C; font-weight: 500; }

		.wrapper { padding: 20px !important; width: 690px;border: 1px solid #EDEDED; margin: 10px auto; -moz-box-shadow: 4px 4px 0 #EDEDED, 1px 1px 0 #D6D6D6;  }

		/* Button */
		.button {
		  cursor: pointer;
		  font-weight: 500;
		  padding: 1px 12px 2px 12px;
		  text-transform: lowercase;
		  font-size: 15px;
		  text-align: center;
		  color: #fff;
		  -moz-outline-radius: 5px;
		  background: #A8A8A8; outline: 1px solid #A8A8A8;
		}

		.button:hover { background: #E0A51B; outline: 1px solid #E0A51B;  }

		.clicked { background: #E0A51B; outline: 1px solid #E0A51B; }
		.clicked:hover { background: #E0A51B; outline: 1px solid #E0A51B; }

		/* margin-right */
		.mr10 { margin-right: 10px; }

		/* margin-top */
		.mt30 { margin-top: 30px; }
		.mt50 { margin-top: 50px; }

		table#insurances_companies td { padding: 5px 5px 0 0; border-bottom: 1px dashed #D7D9DB;  }
		table#insurances_companies tr:hover { background-color:#E0A51B; color: #fff; font-weight: bold; }
		table#insurance_periods_table td { padding-right: 20px; }
		table#results_koeff {   }
		table#results_koeff td {  border: 1px solid #DEDEDE; padding: 1px; }
		table#results_koeff td { font-size: small;  }
		

		#fee_container { display: none }
		#КС, #KBM, .insurance_period { height: 25px; }
		#going_to_reg_div { display: table-cell;text-align: center;height:50px;vertical-align:middle;}
		#going_to_reg_div * { vertical-align: middle; }
		#KC_selector, #KBM_selector, .insurance_period { width:200px }

		.going_to_reg {  }

		.ui-widget-content {
			background: url("images/ui-bg_inset-hard_100_fcfdfd_1x100.png") repeat-x scroll 50% bottom #E0A51B;
			border: 1px solid #FFFFFF;
			color: #222222;
		}
		.ui-state-default, .ui-widget-content .ui-state-default {
			background: url("images/ui-bg_glass_85_dfeffc_1x400.png") repeat-x scroll 50% 50% #E0A51B;
			border: 1px solid #E0A51B;
			color: #E0A51B;
			font-weight: bold;
			outline: medium none;
		}
		.ui-slider { position: relative; text-align: left; }
		.ui-slider .ui-slider-handle { position: absolute; z-index: 2; width: .3em; height: 1em; cursor: default; }
		.ui-slider .ui-slider-range { position: absolute; z-index: 1; font-size: .7em; display: block; border: 0; }

		.ui-slider-horizontal { height: .3em;  }
		.ui-slider-horizontal .ui-slider-handle { top: -.4em; margin-left: -.1em; }
		.ui-slider-horizontal .ui-slider-range { top: 0; height: 100%; }
		.ui-slider-horizontal .ui-slider-range-min { left: 0; }
		.ui-slider-horizontal .ui-slider-range-max { right: 0; }

		.hidden { display: none; }

	</style>
</xsl:template>

<xsl:template name="javascript">
	<script type='text/javascript' encoding='utf-8' src="jquery-1.4.2.min.js"></script>
	<script type='text/javascript' encoding='utf-8' src="jquery-ui-1.8.custom.min.js"></script>
	<script type='text/javascript' encoding='utf-8'>
	
		/*
			ТБ  - Базовые страховые тарифы
			
			КТ  - Коэффициент страховых тарифов в зависимости от территории преимущественного использования транспортного средства
			
			КБМ - Коэффициент страховых тарифов в зависимости от наличия или отсутствия страховых выплат при наступлении страховых случаев, 
				  произошедших в период действия предыдущих договоров обязательного страхования гражданской ответственности владельцев 
				  транспортных средств (далее - договор обязательного страхования)
			
			КО  - Коэффициент страховых тарифов в зависимости от наличия сведений о количестве лиц, допущенных к управлению транспортным средством 
				  Примечание. 
				  В случае ограничения количества лиц, допущенных к управлению транспортным средством, 
				  в договоре обязательного страхования указываются все лица, допущенные к управлению транспортным средством, независимо от их числа.
				  
			КВС - Коэффициент страховых тарифов в зависимости от возраста и стажа водителя, допущенного к управлению транспортным средством
				  Примечания: 
				  1. Если в страховом полисе указано более одного допущенного к управлению транспортным средством лица, 
					 к расчету страховой премии принимается максимальный коэффициент КВС, определенный в отношении лиц, 
					 допущенных к управлению транспортным средством.
				  2. Если договором обязательного страхования не предусмотрено ограничение количества лиц, допущенных 
					 к управлению транспортным средством (коэффициент КО - 1,7), то принимается коэффициент КВС - 1.
			
			КМ  - Коэффициент страховых тарифов в зависимости от мощности двигателя легкового автомобиля (транспортные средства категории "B")
			
			КС  - Коэффициент страховых тарифов в зависимости от периода использования транспортного средства
			
			КП  - Коэффициент страховых тарифов в зависимости от срока страхования
				  Примечание. 
				  Для владельцев транспортных средств, следующих к месту регистрации, 
				  срок страхования составляет до 20 дней включительно, и применяется коэффициент КП - 0,2.
			
			КН  - При наличии нарушений, предусмотренных пунктом 3 статьи 9 Федерального закона "Об обязательном страховании гражданской ответственности владельцев транспортных средств", применяется коэффициент  - 1,5.
			
			
			Формулы:
			
			
			
			1. При ОСГО владельцев ТС, зарегистрированных в Российской Федерации (за исключением случаев следования к месту регистрации)
			
			категория ТС 						- формула для физ. лиц 							- юр. лица
			
			категории "B" (в том числе такси)   Т = ТБ x КТ x КС x КБМ x КВС x КО x КН	x КМ	Т = ТБ x КТ x КБМ x КО x КМ x КС x КН,  где КО = 1,7
			
			категории "А", "С", "D", 			Т = ТБ x КТ x КС x КБМ x КВС x КО x КН			Т = ТБ x КТ x КБМ x КО x КС x КН,	где КО = 1,7
			(в том числе такси),
			троллейбусы, трамваи,
			тракторы, самоходные
			дорожно-строительные
			и иные машины
			
			Прицепы (в том числе				Т = ТБ x КТ x КС								Т = ТБ x КТ x КС
			полуприцепы и прицепы-
			роспуски), за
			исключением
			принадлежащих
			гражданам прицепов
			к легковым
			автомобилям
			
			2. При ОСГО владельцев ТС, зарегистрированных в Российской Федерации ( в случае следования к месту регистрации )
         
												Т = ТБ x КВС x КО x КМ x КП						Т = ТБ x КО x КМ x КП, где КО = 1,7
												
												Т = ТБ x КВС x КО x КП 							Т = ТБ x КО x КП, где КО = 1,7
												
												Т = ТБ x КП  									Т = ТБ x КП
												
            3. При ОСГО владельцев ТС, зарегистрированных в иностранных государствах и временно используемых на территории РФ 
			
												Т = ТБ x КТ x КБМ x КВС x КО x КМ x КП x КН		Т = ТБ x КТ x КБМ x КО x КМ x КП x КН
												
												Т = ТБ x КТ x КБМ x КВС x КО x КП x КН			Т = ТБ x КТ x КБМ x КО x КП x КН
												
												Т = ТБ x КТ x КП								Т = ТБ x КТ x КП
			
		*/	
		
		function calculate_premium(){
			var result = null;
			
			/* type:
				ru_not_reg - user's auto from russia and except case going to reg
				ru_reg 	   - user's auto from russia and his going to reg
				eng 	   - user's auto is a foreigner
			*/
			var type = $('#vehicle_registration').html();
			
			/* vehicle category */
			var vehicle_category = $('#TB option:selected').attr('vehicle_category');
			
			switch( type ){
				case 'ru_not_reg':
					params = {
								'cars' : ['TB','KT','KC','KBM','KVC','KO','KH','KM'],
								'other' : ['TB','KT','KC','KBM','KVC','KO','KH'],
								'trailers' : ['TB','KT','KC']
							};
					result = calculate_premium_by_vehicle_category( params[vehicle_category] );
					break;
				case 'ru_reg':
					params = {
								'cars' : ['TB','KVC','KO','KM','KP'],
								'other' :  ['TB','KVC','KO','KP'],
								'trailers' : ['TB','KP'] 
							};
					result = calculate_premium_by_vehicle_category( params[vehicle_category] );
					break;
				case 'eng':
					params = {
								'cars' : ['TB','KT','KBM','KVC','KO','KM','KP','KH'],
								'other' : ['TB','KT','KBM','KVC','KO','KP','KH'],
								'trailers' : ['TB','KT','KP']
							};
					result = calculate_premium_by_vehicle_category( params[vehicle_category] );
					break;
			};
			
			if( result !== null ){
				$('#fee').html(result);
				$('#fee_container').show();
				$('#not_enoth').hide();
			}
			else {
				$('#fee_container').hide();
				$('#not_enoth').show();
			}
			
			
			return result;
		};
	
		function calculate_premium_by_vehicle_category( vehicle_category_params ){
			var result = null;
			
			//alert(vehicle_category_params);
			for( var item in vehicle_category_params ){
				try{
					var $id = $('#' + vehicle_category_params[item]);
					
					if( $id.attr('disabled') || $id.attr('disabled') == 'disabled' ){
						
						var $id_value = $id.attr('default_value');
					}
					else {
						var $id_value = $id.attr('value');
					}
					
					if( $id_value !== 'undefined' &amp;&amp; $id_value !== null ){
						//alert(vehicle_category_params[item] + ': ' + $id_value);
						result = (result || 1) * parseFloat( $id_value );
					}
					else {
						throw new Error;
					}
				}
				catch(er){
					break;
					return null;
				}
			}
			
			return result;
		};

		$(function(){


			function button_clicked(){
				var $button = $(this);

				if( !$button.hasClass('clicked') ){
					$button.addClass('clicked');
				}

				$button.parent().find('.button').each(function(){
					if( $(this).attr('value') != $button.attr('value') &and; $(this).hasClass('clicked') ){
						$(this).removeClass('clicked');
					}
				});

				return false;
			};

			$('.button').bind('click',button_clicked);

			function vehicle_reg(){
				var $going_to_reg = $('.going_to_reg');
				var $KO_bar = $('.KO_bar');
				var $KH = $('.KH');

				if( $(this).attr('value') == 'yes' ){
					$('#vehicle_registration').html('eng');
				
					$("#KP_ru_reg, #KP_ru_not_reg").addClass('hidden');
					$("#KP, #KP_selector").removeClass('hidden');

					var css_opacity = { 'opacity': 0.3 };
					var options = { 'disabled':'disabled' };
					$("#KC_selector, #KBM_selector").slider("option", "disabled", true).parent().css(css_opacity);

					$('#region option[value=""]').attr({'selected':true}).parent().attr(options).parents('li').css(css_opacity);
					$('#city option[value=""]').attr({'selected':true}).parent().attr(options);
					$('#village option[value=""]').attr({'selected':true}).parent().attr(options);
					$('#KT').attr(options);

					$KO_bar.first().trigger('click').removeClass('clicked');
					$KO_bar.unbind('click').parent().css(css_opacity);
					$KH.unbind('click').parent().css(css_opacity);
					$('#KH').attr(options);

					$going_to_reg.unbind('click').parent().css(css_opacity);
					$going_to_reg.each(function(){
						$going_to_reg.removeClass('clicked');
						if( $(this).attr('value') == 'no' &amp;&amp; !$(this).hasClass('clicked') ){
							$(this).addClass('clicked');
						}
					});
					
					
				}
				else {
					/* reset type */
					$('#vehicle_registration').html('ru_not_eng');
					
					var css_opacity = { 'opacity': 1 };

					$('#term_contract option[value="1"]').attr({'selected':true});

					$('#region').attr('disabled','').parents('li').css(css_opacity);
					$('#city').attr('disabled','');
					$('#village').attr('disabled','');
					$('#KT').attr('disabled','');


					$KO_bar.bind('click',KO_clicked ).parent().css(css_opacity);
					$KO_bar.last().trigger('click').removeClass('clicked');
					$KH.bind('click', KH_clicked ).parent().css(css_opacity);
					$('#KH').attr('disabled','');

					$("#KC_selector, #KBM_selector").slider("option", "disabled", false).parent().css(css_opacity);

					$("#KP_ru_not_reg").removeClass('hidden');
					$("#KP, #KP_selector").addClass('hidden');
					$going_to_reg .bind('click',going_to_reg).removeClass('clicked').parent().css({'opacity': 1});
					$('.button').bind('click',button_clicked);
				}
				
				calculate_premium();
			};

			$('.vehicle_eng').bind('click',vehicle_reg);

			function going_to_reg(){
				var $vehicle_eng = $('.vehicle_eng');
				var $KH = $('.KH');
				
				if( $(this).attr('value') == 'yes' ){
					$('#vehicle_registration').html('ru_reg');
					$(this).attr('disabled','disabled');

					$('#KP_ru_reg').removeClass('hidden');
					$("#KP_ru_not_reg").addClass('hidden');

					var css_opacity = { 'opacity': 0.3 };
					var options = { 'disabled':'disabled' };
					$("#KC_selector, #KBM_selector").slider("option", "disabled", true).parent().css(css_opacity);

					$KH.unbind('click').parent().css(css_opacity);

					$('#region option[value=""]').attr({'selected':true}).parent().attr(options).parents('li').css(css_opacity);
					$('#city option[value=""]').attr({'selected':true}).parent().attr(options);
					$('#village option[value=""]').attr({'selected':true}).parent().attr(options);
					$('#KT').attr(options);

					$vehicle_eng.unbind('click').parent().css({'opacity':0.2});
					$vehicle_eng.each(function(){
						$vehicle_eng.removeClass('clicked');
						if( $(this).attr('value') == 'no' &amp;&amp; !$(this).hasClass('clicked')){
							$(this).addClass('clicked');
						}
					});
					
				}
				else {
					$('#vehicle_registration').html('ru_not_reg');
					var css_opacity = { 'opacity': 1 };

					$('#term_contract option[value="1"]').attr({'selected':true});

					$('#region').attr('disabled','').parents('li').css(css_opacity);
					$('#city').attr('disabled','');
					$('#village').attr('disabled','');
					$('#KT').attr('disabled','');
					
					$vehicle_eng.bind('click',vehicle_reg).removeClass('clicked').parent().css({'opacity':1});
					$("#KC_selector, #KBM_selector").slider("option", "disabled", false).parent().css(css_opacity);

					$KH.bind('click', KH_clicked ).parent().css(css_opacity);
					$('.button').bind('click',button_clicked);
				}
				
				calculate_premium();
			};

			$('.going_to_reg').bind('click',going_to_reg);

			function KO_clicked(){
				var $KVC = $('#KVC');

				if( $(this).attr('value') == 'yes' ){
					$KVC.attr('disabled','disabled');
					$KVC.parent().css('opacity',0.3);
					$('#KO').attr('disabled','disabled');
				}
				else {
					$KVC.attr('disabled','');
					$KVC.parent().css('opacity',1);
					$('#KO').attr('disabled','');
				}
				calculate_premium();
			};

			$('.KO_bar').bind('click',KO_clicked);

			function KH_clicked(){
				if( $(this).attr('value') == 'yes' ){

				}
				else {

				}
				calculate_premium();
			};

			$("#TB").change(function(){
				$('#base_price').html($(this).find('option:selected').val());
				if( $(this).find('option:selected').attr('class') == 'for_KM' ){
					$('#KM').attr('disabled','').parent().css('opacity','1');
				} 
				else {
					$('#KM').attr('disabled','disabled').parent().css('opacity','0.3');
				}
				calculate_premium();
			});
			
			var KC_selector_value = [1,1,1,1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.95,1.0];
			$( "#KC_selector" ).slider({
				range: "min",
				value: 10,
				min: 3,
				max: 10,
				slide: function( event, ui ) {
					var label,
						value = ui.value;

					if( value &lt;= 4 ){
						label = 'месяца';
					}
					else if( value &lt; 10 ) {
						label = 'месяцев';
					}
					else {
						label = 'месяцев и более';
					}

					$( "#КС" ).html( value + ' ' + label );
					$( "#КС" ).attr( 'value',KC_selector_value[value] );
					
					calculate_premium();
				}
			});

			$( "#КС" ).html( $( "#KC_selector" ).slider( "value" ) + ' месяцев и более' );
			$( "#КС" ).attr( 'value',KC_selector_value[10] );

			var KBM_values=[1.0,2.45,2.3,1.55,1.4,1.0,0.95,0.9,0.85,0.8,0.75,0.7,0.65,0.6,0.55,0.5];
			
			$( "#KBM_selector" ).slider({
				range: "min",
				value: 0,
				min: 0,
				max: 15,
				slide: function( event, ui ) {
					var value = ui.value;
					var text;

					if( value != 0 ){
						$('.KH').bind('click', button_clicked).parent().css({'opacity':1});
					}

					if( value == 0 ){
						$('.KH').unbind('click').parent().css({'opacity':0.3});
						text = 'Не страховался ранее';
					}
					else if( value == 1 ) {
						text = 'М';
					} 
					else {
						text = value;
					}
					
					$( "#KBM" ).html( text );
					$( "#KBM" ).attr('value',KBM_values[value]);
					calculate_premium();
				}
			});
			$( "#KBM" ).html( 'Не страховался ранее' );
			$( "#KBM" ).attr('value',KBM_values[0]);
			
			
			var KP_values = [0.2,0.3,0.4,0.5,0.6,0.65,0.7,0.8,0.9,0.95,1.0];
			$( "#KP_selector" ).slider({
				range: "min",
				value: 10,
				min: 0,
				max: 10,
				slide: function( event, ui ) {
					var value = ui.value;
					var text;

					switch( value ){
						case 0 :
							text = 'от 5 до 15 дней';
							break;
						case 1 :
							text = 'от 16 дней до 1 месяца';
							break;
						case 2 :
							text = value + ' месяца';
							break;
						case 3 :
							text = value + ' месяца';
							break;
						case 4 :
							text = value + ' месяца';
							break;
						case 10:
							text = '10 месяцев и более';
							break;
						default:
							text = value + ' месяцев';
							break;
					};
					
					$( "#KP" ).html( text );
					$( "#KP" ).attr('value',KP_values[value]);
					
					calculate_premium();

				}
			});

			$( "#KP" ).html( $( "#KP_selector" ).slider( "value" ) + ' месяцев и более' );
			$( "#KP" ).attr('value',KP_values[10]);

			var insurances_companies_style = {
				hover: { "background-color":"#E0A51B", "color": "#fff", "font-weight": "bold"},
				default : { "background-color":"#FFF", "color": "#000", "font-weight": "500"}
			}
			$('#insurances_companies input').click(function(){

				if( $(this).is(':checked') ){
					$('#insurances_companies tr').each(function(){
						$(this).css(insurances_companies_style.default);
					});
					$(this).parent().parent().css(insurances_companies_style.hover);
				}
			});

			$('.KH').unbind('click').parent().css({'opacity':0.3});
		});
	</script>
</xsl:template>

<xsl:template name="body">
		<div class="wrapper">
					<div style="margin: 20px 0"><h3>Расчет стоимости страхового полиса ОСАГО </h3></div>

					<ul>
						<li>
							<div class="vehicle_eng_div">
								<span class='mr10'>ТС зарегистрировано в иностранном государстве</span>
								<span class="button mr10 vehicle_eng" value='yes'>Да</span>
								<span class="button vehicle_eng" value='no'>Нет</span>
							</div>
						</li>
						<li>
							<div id='going_to_reg_div'>
								<span class='mr10'>ТС следует к месту регистрации</span>
								<span class="button mr10 going_to_reg" value='yes'>Да</span>
								<span class="button going_to_reg" value='no'>Нет</span>
							</div>
						</li>
						<li>
								<h4>Тип (категория) транспортного средства</h4>
								<select name="TB" id="TB">
									<option vehicle_category='cars' class='for_KM' value="1980" selected='selected'>Легковые автомобили</option>
									<option vehicle_category='cars' class='for_KM' value="2965">Легковые автомобили, используемые в качестве такси</option>
									<option vehicle_category='other' value="2965">Автобусы, используемые в качестве такси</option>
									<option vehicle_category='other' value="1620">Автобусы с числом мест сидения до 20 (включительно)</option>
									<option vehicle_category='other' value="2025">Автобусы с числом мест сидения свыше 20</option>
									<option vehicle_category='other' value="2025">Грузовые автомобили с разрешенной максимальной массой 16 тонн и менее</option>
									<option vehicle_category='other' value="3240">Грузовые автомобили с разрешенной максимальной массой более 16 тонн</option>
									<option vehicle_category='other' value="1215">Мотоциклы и мотороллеры</option>
									<option vehicle_category='other' value="1215">Тракторы, самоходные дорожно-строительные и иные машины</option>
									<option vehicle_category='other' value="1010">Трамваи</option>
									<option vehicle_category='other' value="1620">Троллейбусы</option>
									<option vehicle_category='trailers' value="810">Прицепы к грузовым, полуприцепы, прицепы-роспуски</option>
									<option vehicle_category='trailers' value="395">Прицепы к легковым, принадлежащим юридическим лицам, мотоциклам, мотороллерам</option>
									<option vehicle_category='trailers' value="305">Прицепы к тракторам, самоходным дорожно-строительным и иным машинам</option>

								</select>
						</li>
						<li>
								<h4>Мощность двигателя (л. с.)</h4>
								<select name="KM" id="KM" default_value="1.0">
									  <option value="0.6">До 50 включительно</option>
									  <option value="0.9">Свыше 50 до 70 включительно</option>
									  <option value="1.0">Свыше 70 до 100 включительно</option>
									  <option value="1.2">Свыше 100 до 120 включительно</option>
									  <option value="1.4">Свыше 120 до 150 включительно</option>
									  <option value="1.6">Свыше 150</option>
								</select>
						</li>
						<li>
							<table id="insurance_periods_table">
								<tr>
									<td valign="top">
										<h4>Срок договора</h4>

										<div class="insurance_period hidden" id="KP_ru_reg">до 20 дней</div>
										<div class="insurance_period" id="KP_ru_not_reg">1 год</div>
										<div class="insurance_period hidden" id="KP" default_value="1.0"></div>
										<div class="insurance_period hidden" id="KP_selector"></div>
									</td>

									<td>
										<h4>Период использования ТС</h4>
										<div id="КС" default_value="1.0"></div>
										<div id="KC_selector"></div>
									</td>
									<td>
										<h4>Класс</h4>
										<div id="KBM" default_value="1.0"></div>
										<div id="KBM_selector"></div>

									</td>
								</tr>
							</table>
						</li>
						<li>
								<h4>Территория преимущественного использования</h4>

								<table>
									<tr>
										<td>
											<h5>Регион/Область</h5>
											<select id='region'><option value=''>--Выберите регион--</option><option value="">Адыгея</option><option value="">Алтай</option><option value="">Алтайский</option><option value="">Амурская</option><option value="">Архангельская</option><option value="">Астраханская</option><option value="">Байконур</option><option value="">Башкортостан</option><option value="">Белгородская</option><option value="">Брянская</option><option value="">Бурятия</option><option value="">Владимирская</option><option value="">Волгоградская</option><option value="">Вологодская</option><option value="">Воронежская</option><option value="">Дагестан</option><option value="">Еврейская</option><option value="">Забайкальский</option><option value="">Забайкальский край Агинский Бурятский</option><option value="">Ивановская</option><option value="">Ингушетия</option><option value="">Иркутская</option><option value="">Иркутская обл Усть-Ордынский Бурятский</option><option value="">Кабардино-Балкарская</option><option value="">Калининградская</option><option value="">Калмыкия</option><option value="">Калужская</option><option value="">Камчатский</option><option value="">Карачаево-Черкесская</option><option value="">Карелия</option><option value="">Кемеровская</option><option value="">Кировская</option><option value="">Коми</option><option value="">Костромская</option><option value="">Краснодарский</option><option value="">Красноярский</option><option value="">Курганская</option><option value="">Курская</option><option value="">Ленинградская</option><option value="">Липецкая</option><option value="">Магаданская</option><option value="">Марий Эл</option><option value="">Мордовия</option><option value="">Москва</option><option value="">Московская</option><option value="">Мурманская</option><option value="">Ненецкий</option><option value="">Нижегородская</option><option value="">Новгородская</option><option value="">Новосибирская</option><option value="">Омская</option><option value="">Оренбургская</option><option value="">Орловская</option><option value="">Пензенская</option><option value="">Пермский</option><option value="">Приморский</option><option value="">Псковская</option><option value="">Ростовская</option><option value="">Рязанская</option><option value="">Самарская</option><option value="">Санкт-Петербург</option><option value="">Саратовская</option><option value="">Саха /Якутия/</option><option value="">Сахалинская</option><option value="">Свердловская</option><option value="">Северная Осетия - Алания</option><option value="">Смоленская</option><option value="">Ставропольский</option><option value="">Тамбовская</option><option value="">Татарстан</option><option value="">Тверская</option><option value="">Томская</option><option value="">Тульская</option><option value="">Тыва</option><option value="">Тюменская</option><option value="">Удмуртская</option><option value="">Ульяновская</option><option value="">Хабаровский</option><option value="">Хакасия</option><option value="">Ханты-Мансийский Автономный округ - Югра</option><option value="">Челябинская</option><option value="">Чеченская</option><option value="">Чувашская Республика -</option><option value="">Чукотский</option><option value="">Ямало-Ненецкий</option><option value="">Ярославская</option></select>
										</td>
										<td>
											<h5>Город</h5>
											<select id='city'>
												<option value=''>--Выбирете город--</option>
											</select>
										</td>
										<td>
											<h5>Населенный пункт</h5>
											<select id='village'>
												<option value=''>--Выбирете населенный пункт--</option>
											</select>
										</td>
									</tr>
								</table>
						</li>


						<li>
							<h4>Лица, допущенные к управлению ТС</h4>
							<span class='mr10'>Без ограничений</span>
							<span class='button mr10 KO_bar' value='yes'>да</span>
							<span class='button KO_bar' value='no'>нет</span>
						</li>

						<li>
							<h4>Возраст и водительский стаж младшего из допущенных к управлению ТС водителей</h4>
							<select name="KVC" id="KVC" default_value='1.5'>
								<option value="">--Выбирете вариант--</option>
								<option value="1.7">До 22 лет включительно со стажем вождения до 3 лет включительно</option>
								<option value="1.5">До 22 лет включительно со стажем вождения свыше 3 лет</option>
								<option value="1.3">От 22 лет и старше со стажем вождения до 3 лет включительно</option>
								<option value="1.0">От 22 лет и старше со стажем вождения свыше 3 лет</option>
							</select>
						</li>

						<li>
							<h4></h4>
							<!-- violations -->
							<span class='mr10'>Имеются грубые нарушения условий страхования</span>
							<span class='button mr10 KH' value='yes'>да</span>
							<span class='button KH' value='no'>нет</span>
						</li>

					</ul>
	</div>

	<div class="wrapper">
					<table width='650px'>
						<tr>
							<td>
							<div style="margin: 20px 0"><h3>Cтраховые компании</h3></div>
							<table width="300px" id="insurances_companies">
								<tr>
									<td>РОСНО</td>
									<td align='center'><input type="radio" name="insurance_company"/></td>
								</tr>
								<tr>
									<td>Альфастрахование</td>
									<td align='center'><input type="radio" name="insurance_company"/></td>
								</tr>
								<tr>
									<td>РОСГОССТРАХ</td>
									<td align='center'><input type="radio" name="insurance_company"/></td>
								</tr>
								<tr>
									<td>Ренессанс Страхование</td>
									<td align='center'><input type="radio" name="insurance_company"/></td>
								</tr>
								<tr>
									<td>УРАЛСИБ</td>
									<td align='center'><input type="radio" name="insurance_company"/></td>
								</tr>
								<tr>
									<td>Спасские ворота</td>
									<td align='center'><input type="radio" name="insurance_company"/></td>
								</tr>
								<tr>
									<td>РЕСО-Гарантия</td>
									<td align='center'><input type="radio" name="insurance_company"/></td>
								</tr>
							</table>
							</td>
							<td align='center'>
								<p><span>Базовый тариф</span>: <span id="base_price">1980</span>&nbsp;руб.</p>
								<p><b>Взнос составляет</b>: <span id='not_enoth'>недостаточно данных</span><span id="fee_container"><span id="fee"></span>&nbsp;руб.</span></p>					
								<!--<p align='left' style="margin-top: 10px;"><a href='#'><small>Коэффициенты</small></a></p>-->
								
								<div style="display:none">
								<span id="vehicle_registration">ru_not_reg</span>
								<span id="KT" default_value="1.6"></span>
								<span id="KO" default_value="1.0"></span>
								<span id="KH" default_value="1.0"></span>
								</div>
        <!--
								<table id="results_koeff">
									<tr>
										<td width="220">по мощности</td>
										<td width="120"></td>
									</tr>
									<tr>
										<td>по сроку страхования</td>
										<td></td>
									</tr>
									
									<tr>
										<td>по периоду использования</td>
										<td></td>
									</tr>
									<tr>
										<td>по классу</td>
										<td></td>
									</tr>
									<tr>
										<td>по территории использования</td>
										<td></td>
									</tr>
									<tr>
										<td>по возрасту и стажу</td>
										<td></td>
									</tr>
									<tr>
										<td>по допуску лиц к управлению</td>
										<td></td>
									</tr>
									<tr>
										<td>по грубым нарушениям</td>
										<td></td>
									</tr>
								</table>-->
							</td>
						</tr>
					</table> 
	</div>
</xsl:template>

</xsl:stylesheet>
