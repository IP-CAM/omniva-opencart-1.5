<?php echo $header; ?>
<div id="content">
  <div class="breadcrumb">
    <?php foreach ($breadcrumbs as $breadcrumb) { ?>
    <?php echo $breadcrumb['separator']; ?><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
    <?php } ?>
  </div>
  <?php if ($error_warning) { ?>
  <div class="warning"><?php echo $error_warning; ?></div>
  <?php } ?>
  <div class="box">
    <div class="heading">
      <h1><img src="view/image/shipping.png" alt="" /> <?php echo $text_edit; ?></h1>
      <div class="buttons">
      <a onclick="$('#form').submit();" class="button"><?php echo $button_save; ?></a>
      <a href="<?php echo $cancel; ?>" class="button"><?php echo $button_cancel; ?></a>
      <a onclick="$('#download').val('1');$('#form').submit();" class="button"><?php echo $button_update_terminals;?></i></a>
</div>
    </div>
 <?php if ($error_warning) { ?>
  <div class="warning"><?php echo $error_warning; ?></div>
  <?php } ?>


    <div class="content">

        <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="form">
        <input type="hidden" id="download" name="download" value=0 />
        <table class="form">
          <tr>
          <td>
           <?php echo $entry_url; ?></td>
           <td>
              <input type="text" name="omnivalt_url" value="<?php echo $omnivalt_url; ?>" placeholder="<?php echo $entry_url; ?>" id="input-url" />
              <?php if ($error_url) { ?>
              <div class="text-danger"><?php echo $error_url; ?></div>
              <?php } ?>
            </td>
          
          <tr>
          <td><?php echo $entry_user; ?></td>
          <td>
              <input type="text" name="omnivalt_user" value="<?php echo $omnivalt_user; ?>" placeholder="<?php echo $entry_user; ?>" id="input-key" />
              <?php if ($error_user) { ?>
              <div class="text-danger"><?php echo $error_user; ?></div>
              <?php } ?>
            </td>
            </tr>
          <tr>
            <td><?php echo $entry_password; ?></td>
            <td>
              <input type="password" name="omnivalt_password" value="<?php echo $omnivalt_password; ?>" placeholder="<?php echo $entry_password; ?>" id="input-password" />
              <?php if ($error_password) { ?>
              <div class="text-danger"><?php echo $error_password; ?></div>
              <?php } ?>
            </td>
          </tr>
          <tr>
            <td><?php echo $entry_sender_name; ?></td>
            <td>
              <input type="text" name="omnivalt_sender_name" value="<?php echo $omnivalt_sender_name; ?>" placeholder="<?php echo $entry_sender_name; ?>" id="input-" />
              <?php if ($error_sender_name) { ?>
              <div class="text-danger"><?php echo $error_sender_name; ?></div>
              <?php } ?>
            </td>
          </tr>
          <tr>
            <td><?php echo $entry_sender_address; ?></td>
            <td>
              <input type="text" name="omnivalt_sender_address" value="<?php echo $omnivalt_sender_address; ?>" placeholder="<?php echo $entry_sender_address; ?>" id="input-" />
              <?php if ($error_sender_address) { ?>
              <div class="text-danger"><?php echo $error_sender_address; ?></div>
              <?php } ?>
            </td>
          </tr>
          <tr>
            <td><?php echo $entry_sender_postcode; ?></td>
            <td>
              <input type="text" name="omnivalt_sender_postcode" value="<?php echo $omnivalt_sender_postcode; ?>" placeholder="<?php echo $entry_sender_postcode; ?>" id="input-" />
              <?php if ($error_sender_postcode) { ?>
              <div class="text-danger"><?php echo $error_sender_postcode; ?></div>
              <?php } ?>
            </td>
          </tr>
          <tr>
            <td><?php echo $entry_sender_city; ?></td>
            <td>
              <input type="text" name="omnivalt_sender_city" value="<?php echo $omnivalt_sender_city; ?>" placeholder="<?php echo $entry_sender_city; ?>" id="input-sender_city" />
              <?php if ($error_sender_city) { ?>
              <div class="text-danger"><?php echo $error_sender_city; ?></div>
              <?php } ?>
            </td>
      </tr>
          <tr>
            <td><?php echo $entry_sender_country_code; ?></td>
            <td>
              <input type="text" name="omnivalt_sender_country_code" value="<?php echo $omnivalt_sender_country_code; ?>" placeholder="<?php echo $entry_sender_country_code; ?>" id="input-sender_country_code" />
              <?php if ($error_sender_country_code) { ?>
              <div class="text-danger"><?php echo $error_sender_country_code; ?></div>
              <?php } ?>
        </td>
      </tr>
          <tr>
            <td><?php echo $entry_sender_phone; ?></td>
            <td>
              <input type="text" name="omnivalt_sender_phone" value="<?php echo $omnivalt_sender_phone; ?>" placeholder="<?php echo $entry_sender_phone; ?>" id="input-sender_phone" />
              <?php if ($error_sender_phone) { ?>
              <div class="text-danger"><?php echo $error_sender_phone; ?></div>
              <?php } ?>
        </td>
      </tr>
      <tr>
            <td><?php echo $entry_service; ?></td>
            <td>
                <?php foreach ($services as $service) { ?>
                    <?php if (in_array($service['value'], $omnivalt_service)) { ?>
                    <input type="checkbox" name="omnivalt_service[]" value="<?php echo $service['value']; ?>" checked="checked" />
                    <?php echo $service['text']; ?>
                    <?php } else { ?>
                    <input type="checkbox" name="omnivalt_service[]" value="<?php echo $service['value']; ?>" />
                    <?php echo $service['text']; ?>
                    <?php } ?>
                <?php } ?>
          </td>
      </tr>
      <!-- Prices -->
      <tr>
            <td><?php echo $entry_parcel_terminal_price; ?></td>
            <td>
              <input type="text" name="omnivalt_parcel_terminal_price" value="<?php echo $omnivalt_parcel_terminal_price; ?>" placeholder="<?php echo $entry_parcel_terminal_price; ?>" id="input-parcel-terminal-price" />
        </td>
      </tr>
      <tr>
            <td><?php echo $entry_courier_price; ?></td>
            <td>
              <input type="text" name="omnivalt_courier_price" value="<?php echo $omnivalt_courier_price; ?>" placeholder="<?php echo $entry_courier_price; ?>" id="input-parcel-terminal-price" />
              <?php if ($error_courier_price) { ?>
              <div class="text-danger"><?php echo $error_courier_price; ?></div>
              <?php } ?>
        </td>
      </tr>
      <!-- EE, LV -->
      <tr>
        <td>LV <?php echo $entry_parcel_terminal_price; ?></td>
            <td>
              <input type="text" name="omnivalt_parcel_terminal_pricelv" value="<?php echo $omnivalt_parcel_terminal_pricelv; ?>" placeholder="<?php echo $entry_parcel_terminal_price; ?>" id="input-parcel-terminal-price" />
             <?php if ($error_parcel_terminal_pricelv) { ?>
              <div class="text-danger"><?php echo $error_parcel_terminal_pricelv; ?></div>
              <?php } ?>
        </td>
      </tr>
      <tr>
            <td>LV <?php echo $entry_courier_price; ?></td>
            <td>
              <input type="text" name="omnivalt_courier_pricelv" value="<?php echo $omnivalt_courier_pricelv; ?>" placeholder="<?php echo $entry_courier_price; ?>" id="input-parcel-terminal-price" />
              <?php if ($error_courier_pricelv) { ?>
              <div class="text-danger"><?php echo $error_courier_pricelv; ?></div>
              <?php } ?>
        </td>
      </tr>
      <tr>
            <td>EE <?php echo $entry_parcel_terminal_price; ?></td>
            <td>
              <input type="text" name="omnivalt_parcel_terminal_priceee" value="<?php echo $omnivalt_parcel_terminal_priceee; ?>" placeholder="<?php echo $entry_parcel_terminal_price; ?>" id="input-parcel-terminal-price" />
            <?php if ($error_parcel_terminal_priceee) { ?>
              <div class="text-danger"><?php echo $error_parcel_terminal_priceee; ?></div>
              <?php } ?>
        </td>
      </tr>
      <tr>
            <td>EE <?php echo $entry_courier_price; ?></td>
            <td>
              <input type="text" name="omnivalt_courier_priceee" value="<?php echo $omnivalt_courier_priceee; ?>" placeholder="<?php echo $entry_courier_price; ?>" id="input-parcel-terminal-price" />
              <?php if ($error_courier_priceee) { ?>
              <div class="text-danger"><?php echo $error_courier_priceee; ?></div>
              <?php } ?>
            </td>
      </tr>
<--/ Prices --><tr>
            <td><?php echo $entry_company; ?></td>
            <td>
              <input type="text" name="omnivalt_company" value="<?php echo $omnivalt_company; ?>" placeholder="<?php echo $entry_company; ?>" id="input-company" />
        </td>
      </tr>
      <tr>
            <td><?php echo $entry_bankaccount; ?></td>
            <td>
              <input type="text" name="omnivalt_bankaccount" value="<?php echo $omnivalt_bankaccount; ?>" placeholder="<?php echo $entry_bankaccount; ?>" id="input-bankaccount" />
        </td>
      </tr>
      <tr>
            <td><?php echo $entry_pickupstart; ?></td>
            <td>
              <input type="text" name="omnivalt_pickupstart" value="<?php echo $omnivalt_pickupstart; ?>" placeholder="<?php echo $entry_pickupstart; ?>" id="input-pickupstart" />
        </td>
      </tr>
      <tr>
            <td><?php echo $entry_pickupfinish; ?></td>
            <td>
              <input type="text" name="omnivalt_pickupfinish" value="<?php echo $omnivalt_pickupfinish; ?>" placeholder="<?php echo $entry_pickupfinish; ?>" id="input-pickupfinish" />
        </td>
      </tr>
      <tr>
            <td><?php echo $entry_pickup_type; ?></td>
            <td>
              <select name="omnivalt_pickup_type" id="input-pickup-type">
                <?php if ($omnivalt_pickup_type == 'parcel_terminal') { ?>
                <option value="parcel_terminal" selected="selected"><?php echo $text_parcel_terminal; ?></option>
                <?php } else { ?>
                <option value="parcel_terminal"><?php echo $text_parcel_terminal; ?></option>
                <?php } ?>
                <?php if ($omnivalt_pickup_type == 'courier') { ?>
                <option value="courier" selected="selected"><?php echo $text_courier; ?></option>
                <?php } else { ?>
                <option value="courier"><?php echo $text_courier; ?></option>
                <?php } ?>
                <?php if ($omnivalt_pickup_type == 'sorting_center') { ?>
                <option value="sorting_center" selected="selected"><?php echo $text_sorting_center; ?></option>
                <?php } else { ?>
                <option value="sorting_center"><?php echo $text_sorting_center; ?></option>
                <?php } ?>
              </select>
        </td>
      </tr>
      <tr>
          <td><?php echo $entry_cod; ?></td>
            <td>
              <select name="omnivalt_cod" id="input-cod">
                <?php if ($omnivalt_cod) { ?>
                <option value="1" selected="selected"><?php echo $text_enabled; ?></option>
                <option value="0"><?php echo $text_disabled; ?></option>
                <?php } else { ?>
                <option value="1"><?php echo $text_enabled; ?></option>
                <option value="0" selected="selected"><?php echo $text_disabled; ?></option>
                <?php } ?>
              </select>
        </td>
      </tr>
      <tr>
            <td><?php echo $entry_status; ?></td>
            <td>
              <select name="omnivalt_status" id="input-status">
                <?php if ($omnivalt_status) { ?>
                <option value="1" selected="selected"><?php echo $text_enabled; ?></option>
                <option value="0"><?php echo $text_disabled; ?></option>
                <?php } else { ?>
                <option value="1"><?php echo $text_enabled; ?></option>
                <option value="0" selected="selected"><?php echo $text_disabled; ?></option>
                <?php } ?>
              </select>
        </td>
      </tr>
      <tr>
            <td><?php echo $entry_sort_order; ?></td>
            <td>
              <input type="text" name="omnivalt_sort_order" value="<?php echo $omnivalt_sort_order; ?>" placeholder="<?php echo $entry_sort_order; ?>" id="input-sort-order" />
        </td>
      </tr>
      <tr>
                    <td><?php echo $entry_terminals; ?></td>
                    <td id="terminals">
                        <?php echo (isset($omnivalt_terminals['omnivalt_terminals_LT'])?count($omnivalt_terminals['omnivalt_terminals_LT']):0); ?>
      </tr>
         <!-- Field for email templates -->
            <tr>
              <td>
                    <?=$text_email_templates_head;?><br />
                    <?= $text_enabled_disabled;?>
                    <input 
                    <?php if($omnivalt_enable_templates == 'on') print 'checked'; ?>
                    type="checkbox"
                    name="omnivalt_enable_templates">
                    <br /><?=$text_email_templates;?>
                    
                </td>
                <td>
                      <textarea 
                        class="form-control" rows="5" 
                        name="omnivalt_email_template"
                        placeholder="Text to send then parcel is sent.">
                        <?php echo $omnivalt_email_template;?>
                      </textarea>
                </td>
            </tr>
        <!--/ Field for email templates -->
        </form>

</div>
<?php echo $footer; ?>
