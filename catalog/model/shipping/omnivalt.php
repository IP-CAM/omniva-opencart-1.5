<?php
class ModelShippingOmnivalt extends Model {
	function getQuote($address) {
    $currency = "EUR";
    $total_kg = $this->cart->getWeight();
    $weight_class_id = $this->config->get('config_weight_class_id');
    $unit = $this->db->query("SELECT unit FROM " . DB_PREFIX . "weight_class_description wcd WHERE (weight_class_id = " . $weight_class_id . ") AND language_id = '" . (int)$this->config->get('config_language_id') . "'");
    $unit = $unit->row['unit'];
    if ($unit == 'g') {
        $total_kg /= 1000;
    }
    $this->load->language('shipping/omnivalt');

		$method_data = array();
    $services = $this->config->get('omnivalt_service');
    if (is_array($services) && count($services) && $address['iso_code_2'] == 'LT' || $address['iso_code_2'] == 'LV' || $address['iso_code_2'] == 'EE'){
      foreach ($services as $key=>$service){
        $cabine_select = '';
        $first = '';
        $cost = $this->config->get('omnivalt_'.$service.'_price');
        //Adition for Latvia pricing
        if($address['iso_code_2'] == 'LV' && $service == "parcel_terminal")
            $cost = $this->config->get('omnivalt_parcel_terminal_pricelv'); 
        if($address['iso_code_2'] == 'LV' && $service == "courier")
            $cost = $this->config->get('omnivalt_courier_pricelv');     
        if($address['iso_code_2'] == 'EE' && $service == "parcel_terminal")
            $cost = $this->config->get('omnivalt_parcel_terminal_priceee');  
        if($address['iso_code_2'] == 'EE' && $service == "courier")
            $cost = $this->config->get('omnivalt_courier_priceee');
    
        if (stripos($cost,':') !== false){
          $prices = explode(',',$cost);
          if (!is_array($prices)){
            continue;
          }
          $cost = false;
          foreach($prices as $price){
            $priceArr = explode(':',str_ireplace(array(' ',','),'',$price));
            if (!is_array($priceArr) || count($priceArr) != 2){
              continue;
            }
            if ($priceArr[0] >= $total_kg){
              $cost = $priceArr[1];
              break;
            }
          }
        }
        if ($cost === false)
          continue;
        $title = $this->language->get('text_'.$service);
        if ($service == "parcel_terminal" && $cabins = $this->config->get('omnivalt_terminals_LT')){
          $cabine_select ='';
          $cabine_select .= '<script>$( "input[name=shipping_method]" ).focus(function() { $( this ).blur(); });
          $(".omniva_terminal_opt").parent().parent().hide();
          </script>
<select name="omnivalt_parcel_terminal" id="omnivalt_parcel_terminal" class="form-control form-inline input-sm" style="width: 40%; display: inline;"
onchange="$(\'#omnivalt_parcel_terminal\').parent().parent().parent().find(\'td input\').val($(this).val()); $(\'#omnivalt_parcel_terminal\').parent().parent().parent().find(\'td input\').prop(\'checked\',true);" 
onfocus="$(\'#omnivalt_parcel_terminal\').parent().parent().parent().find(\'tdd input\').prop(\'checked\',true);">';
            usort($cabins,function($a,$b){ if ($a[1] ==  $b[1]) return ($a[0] < $b[0]) ? -1 : 1; return ($a[1] < $b[1]) ? -1 : 1; });
            $cabine_select .= $this->groupTerminals($cabins, $address['iso_code_2']);

            foreach ($cabins as $cabin) {   
                    if (!$first) $first = $cabin[3];

                    $sub_quote['parcel_terminal_' .$cabin[3]] = array(
                        'code'         => 'omnivalt.parcel_terminal_' . $cabin[3],
                        'title'        => '<div class="omniva_terminal_opt">'.$title.': '.$cabin[0].' '.$cabin[2].'</div>',
                        'cost'         => $this->currency->convert($cost, $currency, $this->config->get('config_currency')),
                        'tax_class_id' => 0,
                        'text'         => ' '.$this->currency->format($this->currency->convert($cost, $currency, $this->session->data['currency']), $this->session->data['currency'])
                    );

                    $sub_quote['parcel_terminal_fake' .$cabin[3]] = array( 
                        'code'         => 'omnivalt.parcel_terminal_fake' . $cabin[3],
                        'title'        => '<div id="parcel_terminal_fake' . $cabin[3].'"class="omniva_terminal_opt"><script>$(\'#parcel_terminal_fake'.$cabin[3].'\').parent().parent().parent().hide().prev().hide();</script></div>',
                        'cost'         => $this->currency->convert($cost, $currency, $this->config->get('config_currency')),
                        'tax_class_id' => 0,
                        'text'         => 'fake' 
                    );

            }
            $cabine_select .= '</select>';
            $cabine_select .= '
            <button type="button" id="show-omniva-map" class="omniva-btn"><i id="show-omniva-map" class="fa fa-map-marker-alt fa-lg" aria-hidden="true"></i></button>
            ';
        }
        $code = "omnivalt";
        if ($service == "parcel_terminal")
          $code = 'fake';


      if(isset($cabins))
        $terminalOpt = $this->groupTerminals($cabins);
      else
        $terminalOpt = null;

        $quote_data[$service] = array(
          'code'         => $code.'.'.$service ,
          'title'        => $title.$cabine_select,
          'terminals'    => $terminalOpt,
          'cost'         => $this->currency->convert($cost, $currency, $this->config->get('config_currency')),//$sum,
          'tax_class_id' => 0,
          'text'         => ' '.$this->currency->format($this->currency->convert($cost, $currency, $this->session->data['currency']), $this->session->data['currency'])
        );
      }
      if (!(isset($sub_quote)) || !is_array($sub_quote))
        $sub_quote = array();
      if (!(isset($quote_data)) || !is_array($quote_data))
        return '';
      if (isset($this->request->get['route']) && strpos($this->request->get['route'],'api') === 0) {
          
            $sub_quote = array_filter($sub_quote,function($a){ return (strpos($a,'parcel_terminal') === 0? 0: 1);},ARRAY_FILTER_USE_KEY);
            $quote_data = array_filter($quote_data,function($a){ return (strpos($a,'parcel_terminal') === 0? 0: 1);},ARRAY_FILTER_USE_KEY);
        }
      $method_data = array(
        'code'       => 'omnivalt',
        'title'      => $this->language->get('text_title'),
        'quote'      => array_merge($quote_data,$sub_quote),
        'sort_order' => $this->config->get('omnivalt_sort_order'),
        'error'      => ''
      );
    }
		return $method_data;
	}
  private function groupTerminals($terminals,$country = 'LT', $selected = ''){
    $parcel_terminals = '';
    if (is_array($terminals)){
      $grouped_options = array();
      foreach ($terminals as $terminal){
        if(isset($terminal[5]) && $terminal[5] == $country) {
        if (!isset($grouped_options[$terminal[1]]))
          $grouped_options[(string)$terminal[1]] = array();
        $grouped_options[(string)$terminal[1]][(string)$terminal[3]] = $terminal[0].', '.$terminal[2];
        }
      }
      foreach ($grouped_options as $city=>$locs){
        $parcel_terminals .= '<optgroup label = "'.$city.'">';
        foreach ($locs as $key=>$loc){
          $parcel_terminals .= '<option class="omnivaOption" value = "omnivalt.parcel_terminal_'.$key.'" '.($key == $selected?'selected':'').'>'.$loc.'</option>';
        }
        $parcel_terminals .= '</optgroup>';
      }
    }
    $parcel_terminals = '<option value = "" selected disabled>'.$this->language->get('text_select_terminal').'</option>'.$parcel_terminals;
    return $parcel_terminals;
  }
}

