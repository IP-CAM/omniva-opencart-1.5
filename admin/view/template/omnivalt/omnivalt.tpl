<?php echo $header; ?>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-modal/2.2.6/js/bootstrap-modal.js"></script>

<div id="content">
  <div class="breadcrumb">
    <?php foreach ($breadcrumbs as $breadcrumb) { ?>
    <?php echo $breadcrumb['separator']; ?><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
    <?php } ?>
  </div>
  <div class="box">
    <div class="heading">
      <h1><img src="view/image/shipping.png" alt="" /> <?= $text_manifestHead; ?> (<?=$currentManifest;?>)</h1>
      <div class="buttons">
      <a href="<?php echo $cancel; ?>" class="button"><?= $button_cancel; ?></a>
    </div>
</div>

<div class="content">
      <div id="htabs" class="htabs"><a href="#tab-general"><?=$text_new_orders;?></a>
        <a href="#tab-skipped"><?=$text_awaiting;?></a>
        <a href="#tab-history"><?=$text_completed;?></a>
         <a href="#tab-search"><?=$text_search;?></a>
         <a href="#tab-courier"><?=$text_courier;?></a>
        </div>

        <div id="tab-general">
        <?php if(!empty($newOrders)) { ?>
        <form method="POST" action="<?=$labels;?>" id="frm<?=$currentManifest;?>"  target='_blank'>

    <button type='submit' class='btn btn-default btn-sm' form="frm<?=$currentManifest;?>" name='print' class='omniv' value='manifest'><?=$text_manifest;?></button>
    <button type='submit' class='btn btn-default btn-sm' form="frm<?=$currentManifest;?>" name='print' value='labels'><?=$text_labels;?></button>

     <table class='list'>
    <thead>
    <tr>
        <td class='left' width='5%'>id</td>
       <td width='15%'><?=$text_customer;?></td>
        <td width='15%'><?=$text_tracking_num;?></td>
        <td width='15%'><?=$text_date;?></td>
        <td width='15%'><?=$text_total;?></td>
        <td width='15%'></td></tr>
    </thead>
<?php foreach($newOrders as $nOrder) {?>
<tr>
        <td class='left'><?=$nOrder['order_id'];?></td>
        <td width='15%'><a href="<?php echo $client.'&order_id='.$nOrder['order_id'];?>" target="_blank"><?=$nOrder['full_name'];?></a></td>
        <td width='15%'>
               <?php
        $variable = json_decode($nOrder['tracking']);
        for($i=0; $i<count($variable); $i++) {
            echo $variable[$i].'<br>';
        }
        ?>
        </td>
        <td width='15%'><?=$nOrder['date_modified'];?></td>
        <td width='15%'><?=$nOrder['total'];?></td>
        <td width='15%'>
        <a href="<?=$genLabels;?>&order_id=<?=$nOrder['order_id'];?>" target="_blank"><?=$generate_label;?></a>
        <?php if($nOrder['tracking'] != true){ ?>
        <a href="<?=$skip;?>&order_id=<?=$nOrder['order_id'];?>"><?=$text_skip_order;?></a>
        <?php  } ?>
        <input type='hidden' name='selected[]' value="<?=$nOrder['order_id'];?>">
        <?php if($nOrder != null) { ?>
                <input type='hidden' name='manifest' value="<?=$nOrder['manifest'];?>">
        <?php } else { ?>
        <input type='hidden' name='new' value="new">
        <?php } ?>
        </td>
    </tr>

    <?php } ?> 
        </table>
    </form>
    <?php } else { print $text_new_zero;} ?>
        </div>    
        <div id="tab-skipped" class="htabs-content">

<?php if(!empty($skipped)) { ?>
     <table class='list'>
    <thead>
    <tr>
        <td class='left' width='5%'>id</td>
       <td width='15%'><?=$text_customer;?></td>
        <td width='15%'><?=$text_tracking_num;?></td>
        <td width='15%'><?=$text_date;?></td>
        <td width='15%'><?=$text_total;?></td>
        <td width='15%'></td></tr>
    </thead>
    <?php  foreach($skipped as $nOrder) {?>
<tr>
        <td class='left'><?=$nOrder['order_id'];?></td>
        <td width='15%'><a href="<?php echo $client.'&order_id='.$nOrder['order_id'];?>" target="_blank"><?=$nOrder['full_name'];?></a></td>
        <td width='15%'></td>
        <td width='15%'><?=$nOrder['date_modified'];?></td>
        <td width='15%'><?=$nOrder['total'];?></td>
        <td width='15%'>
                <?php if($nOrder['manifest'] == -1){?>
            <a href="<?=$cancelSkip;?>&order_id=<?=$nOrder['order_id'];?>"><?=$text_add_order;?></a>
        <?php } ?>
        </td>
    </tr>
<?php }} else print $text_skipped_zero; ?>
    </table>

          </div>
          <div id="tab-history" class="htabs-content">

<?php 
   /*  if($currentManifest == (intval($orders[0]['manifest']) +1) OR $newPage == null) {
 ?>
<form method="POST" action="<?=$labels;?>" id="frm<?=$currentManifest;?>"  target='_blank'>

    <button type='submit' class='btn btn-default btn-sm' form="frm<?=$currentManifest;?>" name='print' class='omniv' value='manifest'><?=$text_manifest;?></button>
    <button type='submit' class='btn btn-default btn-sm' form="frm<?=$currentManifest;?>" name='print' value='labels'><?=$text_labels;?></button>

    <table class='list'>
    <thead>
    <tr>
        <td class='left' width='5%'>id</td>
          <td width='15%'><?=$text_customer;?></td>
        <td width='15%'><?=$text_tracking_num;?></td>
        <td width='15%'><?=$text_date;?></td>
        <td width='15%'><?=$text_total;?></td>
        <td width='15%'></td></tr>
    </tr>
    </thead>
    <?php } */ ?>
<?php  foreach($orders as $order) {
     if((isset($manifest2) && $order['manifest'] != $manifest2) OR $newPage == null) {
         $newPage = true;
                //print"<tr><td colspan='5'><hr></td><td><input type='submit' value='Manifestas' class='btn btn-primary btn-sm'></form><form method='POST' action=".$labels." target='_blank'></td><tr>";
     ?>
     </table>
     </form>
     <form method="POST" action="<?=$labels;?>" id="frm<?=$order['manifest'];?>"  target='_blank'>

    <button type='submit' form="frm<?=$order['manifest'];?>" class='btn btn-default btn-sm' name='print' class='omniv' value='manifest'><?=$text_manifest;?></button>
    <button type='submit' form="frm<?=$order['manifest'];?>" class='btn btn-default btn-sm' name='print' value='labels'><?=$text_labels;?></button>

    <table class='list'>
    <thead>
    <tr>
        <td class='left' width='5%'>id</td>
       <td width='15%'><?=$text_customer;?></td>
        <td width='15%'><?=$text_tracking_num;?></td>
        <td width='15%'><?=$text_date;?></td>
        <td width='15%'><?=$text_total;?></td>
        <td width='15%'></td></tr>
    </thead>
     <?php
     }
            $manifest2 = $order['manifest'];
    ?>
    <tr>
        <td class='left'><?=$order['order_id'];?></td>
        <td><a href="<?php echo $client.'&order_id='.$order['order_id'];?>"><?=$order['full_name'];?></a></td>
        <td>
        <?php 
        $variable = json_decode($order['tracking']);
        for($i=0; $i<count($variable); $i++) {
            echo $variable[$i].'<br>';
        }
        ?>
        </td>
        <td><?=$order['date_modified'];?></td>
        <td><?=$order['total'];?></td>
        <?php /*<td><?=$order['labels'];?></td>*/?>
        <td ><?php /*echo $order['manifest']; */ ?>
        <a href="<?=$genLabels;?>&order_id=<?=$order['order_id'];?>" target="_blank"><?=$generate_label;?></a>
        <?php if($order['manifest'] == -1){?>
            <a href="<?=$cancelSkip;?>&order_id=<?=$order['order_id'];?>">ERROR forgot to delete</a>
        <?php } ?>
        <input type='hidden' name='selected[]' value="<?=$order['order_id'];?>">
        <input type='hidden' name='manifest' value="<?=$order['manifest'];?>">
        </td>
    </tr>

<?php } ?>   </form></td>
    </table> 
            <div style='text-align: center'><?php echo $pagination; ?></div>
      
    </div>
        
<!-- search -->
<div id="tab-search">
    <table class='list'>
    <thead>
    <tr>
        <td class='left' width='5%'>id</td>
       <td width='15%'><?=$text_customer;?></td>
        <td width='15%'><?=$text_tracking_num;?></td>
        <td width='15%'><?=$text_date;?></td>
        <td width='15%'><?=$text_total;?></td>
        <td width='15%'></td></tr>
    </tr>
   
    <tr class="filter">
        <td class='left' width='5%'>#</td>
        <td><input type="text" name="customer" value="" class="ui-autocomplete-input"  role="textbox" aria-autocomplete="list" aria-haspopup="true"></td>
        <td>                
        <input type="text" name="tracking_nr" value="" class="form-control">
        </td>
        <td>
        <input type="text" name="date_added" id="omnivaDate" value="" size="12" class="date">
        </td>
        <td>
        <input type="text" name="asdas" value="" disabled />
        </td>
        <td><a class="button" id="button-search"><?=$text_filter;?></a></td>
    </tr>
     </thead>
    <tbody id="searchTable">
    </tbody>
    </table>
        
</div>
<!--/ endsearch -->
<!-- Callin Courier -->
    <div id="tab-courier">

<div class="modal-body">
            <div class="">
                    <strong>Svarbu!</strong> Vėliausias galimas kurjerio iškvietimas yra iki 15val. Vėliau iškvietus kurjerį negarantuojame, jog siunta bus paimta.
                    <br />
                    <strong>El-parduotuvės adreso nustatymus</strong>  galima keisti Omnivalt modulio nustatymuose.
            </div><hr>
            <h4>Siunčiami duomenys</h4>
            <b>Siuntėjas:</b> <?= $sender;?>,<br>
            <b>Telefonas:</b> <?= $phone;?>,<br>
            <b>Pašto kodas:</b> <?= $address;?>,<br>
            <b>Adresas:</b> <?= $address;?>.<br>
            <hr><!--
                <label class="control-label col-sm-3" for="email"> Tema (neprivaloma)</label>
                
                <input type="text" name="commentOmnivalt" class="form-control" id="email" placeholder="komentaras" value="informacija apie naujas siuntas">
            <hr>-->
      </div>
      <div class="modal-footer">
            <button type="submit"  id="requestOmnivaltQourier" class="btn btn-default"><?=$text_callCourier;?></button>
      </div>
    </form>
    </div>
</div>
<!--/ Callin Courier -->
 
</div>
<!-- Latest compiled and minified JavaScript -->
<script type="text/javascript"><!--
$('.vtabs a').tabs();
$('.htabs a').tabs();

//--></script>


<script type="text/javascript"><!--
$(document).ready(function() {
	$('.date').datepicker({dateFormat: 'yy-mm-dd'});
});
//--></script> 
<script>
$(document).ready(function() {
    $('#button-search').on('click', function() {
        var tracking = $('input[name="tracking_nr"]').val();
        var customer = $('input[name="customer"]').val();
        var dateAdd = $('input[name="input-date-added"]').val();
    console.log(tracking, customer, dateAdd);
        	$.ajax({
		url: 'index.php?route=omnivalt/omnivalt/searchOmnivaOrders&token=<?php echo $token; ?>',
		type: 'post',
        dataType: 'json',
        data: $('input[name="tracking_nr"], input[name="customer"], input[id="omnivaDate"]'),
        beforeSend: function() {
            $('#searchTable').empty();
        },
		success: function(data) {
			
       console.log(typeof(data));
        console.log(data);
        if(Array.isArray(data)) {
        for(gotOrder of data){
            //console.log(gotOrder);
            $('#searchTable').append("<tr><td class='left'>"+gotOrder['order_id']+"</td>\
                <td> <a href='index.php?route=sale/order/info&token=<?php echo $token; ?>&order_id="+gotOrder['order_id']+"' target='_blank'>"+gotOrder['full_name']+"</a></td>\
                <td> "+gotOrder['tracking']+"</a></td>\
                <td>"+gotOrder['date_modified']+"</td>\
                <td>"+gotOrder['total']+"</td>\
                <td> <a href='index.php?route=extension/shipping/omnivalt/labels&token=<?php echo $token; ?>&order_id="+gotOrder['order_id']+"' target='_blank'>Generuoti lipdukus</a></td>\
            </tr>");
        }
        }
        if(data.length<1)
            $('#searchTable').append("<tr><td colspan='6'>Not found.</td>");   
		},
    		error: function(xhr, ajaxOptions, thrownError) {
			/* alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText); */
		}
	});
    });
});
</script>
<script>
$(document).ready(function() {
 $('#requestOmnivaltQourier').on('click', function(e) {
     e.preventDefault();
	$.ajax({
		url: 'index.php?route=omnivalt/omnivalt/callCarrier&token=<?php echo $token; ?>',
		type: 'get',
    data:  {'labelsCount': 5, 
            'order_id': 5},
	
		success: function(data) {

            if(data == 'got_request'){
                $('.modal-body').append('<div class="alert alert-success" id="remove">\
                 <h4><strong>Baigta!</strong> Pranešimas sėkmingai išsiųstas.</h4>\
                </div>');
            } else {
                $('.modal-body').append('<div class="alert alert-danger" id="remove">\
                 <h4><strong>Deja!</strong> klaidingas atsakymas.</h4>\
                </div>');
            }

        setTimeout(function(){
            $('#remove').remove();
            $('#myModal').modal('hide');
            }, 3000);
                
		},
    		error: function(xhr, ajaxOptions, thrownError) {
			alert(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
		}
	});
 });
});
</script>
<?php
echo $footer;
