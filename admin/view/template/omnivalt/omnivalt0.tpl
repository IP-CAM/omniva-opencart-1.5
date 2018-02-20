<?php echo $header; ?>
<div id="content">
  <div class="breadcrumb">
    <?php foreach ($breadcrumbs as $breadcrumb) { ?>
    <?php echo $breadcrumb['separator']; ?><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
    <?php } ?>
  </div>
  <div class="box">
    <div class="heading">
      <h1><img src="view/image/shipping.png" alt="" /> <?php echo $text_manifestHead; ?> (<?=$currentManifest;?>)</h1>
      <div class="buttons">
      <a href="<?php echo $cancel; ?>" class="button"><?php echo $button_cancel; ?></a>
    </div>
</div>
</div>
    <table class='list'>
    <form method="POST" action="<?=$labels;?>" id="frm<?=$currentManifest;?>"  name="frm<?=$currentManifest;?>" target='_blank'>

    <button type='submit' form="frm<?=$currentManifest;?>" name='print' class='omniv' value='manifest'>Manifestas</button>
    <button type='submit' form="frm<?=$currentManifest;?>" name='print' value='labels'>Lipdukai</button>
    <thead>
    <tr>
        <td class='left' width='5%'>id</td>
        <td width='15%'>Pirkejas</td>
        <td width='15%'>Siuntos nr.</td>
        <td width='15%'>Atnaujinimo data</td>
        <td width='15%'>Suma</td>
        <td width='15%'></td></tr>
    </thead>
    <tbody>
<?php  foreach($orders as $order) {
     //var_dump($order);
     if(isset($manifest) && $order['manifest'] != $manifest) {?>
 
        </table>
        </form>
        <form method="POST" action="<?=$labels;?>" id="frm<?=$order['manifest'];?>" target='_blank'>
          <button type='submit' form="frm<?=$order['manifest'];?>" name='print' value='manifest'>Manifestas</button>
          <button type='submit' form="frm<?=$order['manifest'];?>" name='print' value='labels'>Lipdukai</button>
    <table class='list'>
    <thead>
    <tr>
        <td class='left' width='5%'>id</td>
        <td width='15%'>Pirkejas</td>
        <td width='15%'>Siuntos nr.</td>
        <td width='15%'>Atnaujinimo data</td>
        <td width='15%'>Suma</td>
        <td width='15%'></td></tr>
    </thead>
    <tbody>
        <?php
        }
    $manifest = $order['manifest'];
    ?>
    <tr>
        <td class='left'><?=$order['order_id'];?></td>
        <td width='15%'><a href="<?php echo $client.'&order_id='.$order['order_id'];?>" target="_blank"><?=$order['full_name'];?></a></td>
        <td width='15%'>
        <?php 
        //var_dump(json_decode($order['tracking']));
        $variable = json_decode($order['tracking']);
        for($i=0; $i<count($variable); $i++) {
            echo $variable[$i].'<br>';
        }
        ?>
        </td>
        <td width='15%'><?=$order['date_modified'];?></td>
        <td width='15%'><?=$order['total'];?></td>
        <td width='15%'>
        <a href="<?=$genLabels;?>&order_id=<?=$order['order_id'];?>" target="_blank">Generuoti lipdukus</a>
        <input type='hidden' name='selected[]' value="<?=$order['order_id'];?>">
        <input type='hidden' name='manifest' value="<?=$order['manifest'];?>">
        </td>
    </tr>

<?php 
}?>
</tbody>
    </table>
        <?php echo $pagination; ?>
</div>
<?php
echo $footer;