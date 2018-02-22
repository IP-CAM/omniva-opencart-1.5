<?php
/**
 * Controller for listing omnivalt orders and creating manifest
 *
 * As well saving its history for futher review
 */
class ControllerOmnivaltOmnivalt extends Controller
{
    public function index()
    {
        $this->load->language('shipping/omnivalt');
        $this->data['heading_title'] = $this->language->get('heading_title');
        $manifest = intval($this->config->get('omniva_manifest'));
        $numRows = $this->db->query("SELECT COUNT(*)
                                        FROM " . DB_PREFIX . "order A
                                        LEFT JOIN " . DB_PREFIX . "order_omniva B ON A.order_id = B.id_order
                                        WHERE order_status_id != 0 AND shipping_code LIKE 'omnivalt%' AND B.tracking IS NOT NULL AND B.manifest != $manifest AND B.manifest != -1
                                        ")->rows;
        if ($numRows) {
            $numRows = intval($numRows[0]["COUNT(*)"]);
        }

        $this->data['countRows'] = $numRows;

        if (isset($this->request->get['page'])) {
            $page = $this->request->get['page'];
        } else {
            $page = 1;
        }

        $start = ($page - 1) * 70;
        $limit = 70;

        $pagination = new Pagination();
        $pagination->total = $numRows;
        $pagination->page = $page;
        $pagination->limit = $limit;
        $pagination->url = $this->url->link('omnivalt/omnivalt', 'token=' . $this->session->data['token'] . '&page={page}', 'SSL');

        $this->data['pagination'] = $pagination->render();

        $orders = $this->db->query("SELECT order_id, total, date_modified, CONCAT(firstname, ' ', lastname) AS full_name, B.tracking, B.manifest, B.labels, B.id_order
                                    FROM " . DB_PREFIX . "order A
                                    LEFT JOIN " . DB_PREFIX . "order_omniva B ON A.order_id = B.id_order
                                    WHERE order_status_id != 0 AND shipping_code LIKE 'omnivalt%' AND B.tracking IS NOT NULL AND B.manifest != $manifest AND B.manifest != -1
                                    ORDER BY manifest DESC, order_id DESC
                                    LIMIT $start, $limit
                                    ;");
        $newOrders = $this->db->query("SELECT order_id, total, date_modified, CONCAT(firstname, ' ', lastname) AS full_name, B.tracking, B.manifest, B.labels, B.id_order
                                    FROM " . DB_PREFIX . "order A
                                    LEFT JOIN " . DB_PREFIX . "order_omniva B ON A.order_id = B.id_order
                                    WHERE order_status_id != 0 AND shipping_code LIKE 'omnivalt%' AND (B.tracking IS NULL OR B.manifest = $manifest)
                                    ORDER BY order_id DESC
                                    ;");
        $skipped = $this->db->query("SELECT order_id, total, date_modified, CONCAT(firstname, ' ', lastname) AS full_name, B.tracking, B.manifest, B.labels, B.id_order
                                    FROM " . DB_PREFIX . "order A
                                    LEFT JOIN " . DB_PREFIX . "order_omniva B ON A.order_id = B.id_order
                                    WHERE order_status_id != 0 AND shipping_code LIKE 'omnivalt%' AND B.manifest = -1
                                    ORDER BY order_id DESC
                                    ;");
        $this->data['skipped'] = $skipped->rows;
        $this->data['newOrders'] = $newOrders->rows;
        $this->data['newPage'] = $newOrders->rows;
        $this->data['newPage'] = null;

        $this->data['orders'] = $orders->rows;

        $this->data['breadcrumbs'] = array();

        $this->data['breadcrumbs'][] = array(
            'text' => $this->language->get('text_home'),
            'href' => $this->url->link('common/home', 'token=' . $this->session->data['token'], true),
            'separator' => false,
        );

        $this->data['breadcrumbs'][] = array(
            'text' => $this->language->get('text_shipping'),
            'href' => $this->url->link('extension/shipping', 'token=' . $this->session->data['token'] . '&type=shipping', true),
            'separator' => false,

        );
        $this->data['breadcrumbs'][] = array(
            'text' => $this->language->get('text_manifest'),
            'href' => $this->url->link('omnivalt/omnivalt', 'token=' . $this->session->data['token'], true),
            'separator' => false,

        );
        $this->data['text_manifestHead'] = $this->language->get('text_manifestHead');
        $this->data['text_newManifest'] = $this->language->get('text_newManifest');
        $this->data['skip'] = $this->url->link('omnivalt/omnivalt/skipOrder', 'token=' . $this->session->data['token'], true);
        $this->data['cancelSkip'] = $this->url->link('omnivalt/omnivalt/cancelSkip', 'token=' . $this->session->data['token'], true);
        $this->data['button_cancel'] = $this->language->get('button_cancel');
        $this->data['cancel'] = $this->url->link('common/home', 'token=' . $this->session->data['token'] . '&type=shipping', true);
        $this->data['client'] = $this->url->link('sale/order/info', 'token=' . $this->session->data['token'], true);
        $this->data['labels'] = $this->url->link('shipping/omnivalt/printDocs', 'token=' . $this->session->data['token'], true);
        $this->data['genLabels'] = $this->url->link('shipping/omnivalt/labels', 'token=' . $this->session->data['token'], true);
        $this->data['currentManifest'] = intval($this->config->get('omniva_manifest'));
        $this->data['newManifest'] = 'Naujas Manifestas';
        $this->template = 'omnivalt/omnivalt.tpl';

        $this->data['token'] = $this->session->data['token'];
        $this->data['sender'] = $this->config->get('omnivalt_sender_name');
        $this->data['phone'] = $this->config->get('omnivalt_sender_phone');
        $this->data['postcode'] = $this->config->get('omnivalt_sender_postcode');
        $this->data['address'] = $this->config->get('omnivalt_sender_country_code') . ' ' . $this->config->get('omnivalt_sender_address');

        /* langs */
        $this->data['text_new_orders'] = $this->language->get('text_new_orders');
        $this->data['text_awaiting'] = $this->language->get('text_awaiting');
        $this->data['text_completed'] = $this->language->get('text_completed');
        $this->data['text_search'] = $this->language->get('text_search');
        $this->data['text_manifest'] = $this->language->get('text_manifest');
        $this->data['text_labels'] = $this->language->get('text_labels');
        $this->data['text_customer'] = $this->language->get('text_customer');
        $this->data['text_date'] = $this->language->get('text_date');
        $this->data['text_total'] = $this->language->get('text_total');
        $this->data['text_skip_order'] = $this->language->get('text_skip_order');
        $this->data['text_add_order'] = $this->language->get('text_add_order');
        $this->data['renew'] = $this->language->get('renew');
        $this->data['text_tracking_num'] = $this->language->get('text_tracking_num');
        $this->data['generate_label'] = $this->language->get('generate_label');
        $this->data['text_skipped_zero'] = $this->language->get('text_skipped_zero');
        $this->data['text_new_zero'] = $this->language->get('text_new_zero');

        $this->data['text_start_search'] = $this->language->get('text_start_search');
        $this->data['text_courier'] = $this->language->get('text_courier');
        $this->data['renew'] = $this->language->get('renew');
        $this->data['text_filter'] = $this->language->get('text_filter');
        $this->data['text_callCourier'] = $this->language->get('text_callCourier');
        $this->data['text_print_labels'] = $this->language->get('text_print_labels');

        /* langs */
        $this->children = array(
            'common/header',
            'common/footer',
        );
        $this->response->setOutput($this->render());
    }
    public function searchOmnivaOrders()
    {
        if (!isset($this->request->post['customer']) and !isset($this->request->post['date_added']) and !isset($this->request->post['tracking_nr'])) {
            return $this->response->setOutput(json_encode(array()));
        }

        $where = '';
        $tracking = $this->request->post['tracking_nr'];
        if ($tracking != '' and $tracking != null and $tracking != 'undefined') {
            $where .= " AND B.tracking LIKE '%" . $tracking . "%'";
        }

        $customer = $this->request->post['customer'];
        if ($customer != '' and $customer != null and $customer != 'undefined') {
            $where .= ' AND CONCAT(firstname, " ", lastname) LIKE "%' . $customer . '%" ';
        }

        $date = $this->request->post['date_added'];
        if ($date != null and $date != 'undefined' and $date != '') {
            $where .= 'AND (date_added LIKE "%' . $date . '%" OR date_modified LIKE "%' . $date . '%" )';
        }

        if ($where == '') {
            return $this->response->setOutput(json_encode(array()));
        }


        $orders = $this->db->query("SELECT order_id, total, date_modified, CONCAT(firstname, ' ', lastname) AS full_name, B.tracking, B.manifest, B.labels, B.id_order
        FROM " . DB_PREFIX . "order A
        LEFT JOIN " . DB_PREFIX . "order_omniva B ON A.order_id = B.id_order
        WHERE order_status_id != 0 AND shipping_code LIKE 'omnivalt%' " . $where . "
        ORDER BY manifest DESC, order_id DESC
        LIMIT 50
        ;");

        $i = 0;
        $orderArrBack = array();
        foreach ($orders->rows as $order) {
            $orderArrBack[$i]['order_id'] = $order['order_id'];
            $orderArrBack[$i]['full_name'] = $order['full_name'];
            $orderArrBack[$i]['tracking'] = $order['tracking'];
            $tracking = json_decode($order['tracking']);
            if ($tracking != null and is_array($tracking)) {
                $tracking = end($tracking);
            } else {
                $tracking = '';
            }

            $orderArrBack[$i]['tracking'] = $tracking;
            $orderArrBack[$i]['date_modified'] = $order['date_modified'];
            $orderArrBack[$i]['total'] = $order['total'];
            $orderArrBack[$i]['labels'] = $order['labels'];
            $i++;
            if ($i > 50) {
                break;
            }

        }
        return $this->response->setOutput(json_encode($orderArrBack));

    }

    public function skipOrder()
    {
        if (!isset($this->request->get['order_id'])) {
            $this->redirect($this->url->link('omnivalt/omnivalt', 'token=' . $this->session->data['token'], true));
        }

        $id_order = $this->request->get['order_id'];
        $none = null;
        $manifest = -1;
        $this->db->query("INSERT INTO " . DB_PREFIX . "order_omniva (tracking, manifest, labels, id_order)
            VALUES ('$none','$manifest','$none','$id_order')");

        $this->redirect($this->url->link('omnivalt/omnivalt', 'token=' . $this->session->data['token'], true));
    }

    public function cancelSkip()
    {
        if (!isset($this->request->get['order_id'])) {
            $this->redirect($this->url->link('omnivalt/omnivalt', 'token=' . $this->session->data['token'], true));
        }

        $id_order = $this->request->get['order_id'];
        $none = null;
        $this->db->query("DELETE FROM " . DB_PREFIX . "order_omniva WHERE id_order=" . $id_order . " AND manifest=-1;");

        $this->redirect($this->url->link('omnivalt/omnivalt', 'token=' . $this->session->data['token'], true));

    }

    public function callCarrier()
    {
        $pickStart = $this->config->get('omnivalt_pickupstart') ? $this->config->get('omnivalt_pickupstart') : '8:00';
        $pickFinish = $this->config->get('omnivalt_pickupfinish') ? $this->config->get('omnivalt_pickupfinish') : '17:00';
        $pickDay = date('Y-m-d');
        if (time() > strtotime($pickDay . ' ' . $pickFinish)) {
            $pickDay = date('Y-m-d', strtotime($pickDay . "+1 days"));
        }

        $xmlRequest = '
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://service.core.epmx.application.eestipost.ee/xsd">
         <soapenv:Header/>
         <soapenv:Body>
            <xsd:businessToClientMsgRequest>
               <partner>' . $this->config->get('omnivalt_user') . '</partner>
               <interchange msg_type="info11">
                  <header file_id="' . \Date('YmdHms') . '" sender_cd="' . $this->config->get('omnivalt_user') . '" >
                  <comment>We are ready to pick</comment>
                  </header>
                  <item_list>
                     <item service="QH" >
                        <measures weight="18" />
                        <receiverAddressee >
                            <person_name>' . $this->config->get('omnivalt_sender_name') . '</person_name>
                            <phone>' . $this->config->get('omnivalt_sender_phone') . '</phone>
                            <address postcode="' . $this->config->get('omnivalt_sender_postcode') . '" deliverypoint="' . $this->config->get('omnivalt_sender_city') . '" country="' . $this->config->get('omnivalt_sender_country_code') . '" street="' . $this->config->get('omnivalt_sender_address') . '" />
                        </receiverAddressee>
                        <!--Optional:-->
                        <returnAddressee>
                           <person_name>' . $this->config->get('omnivalt_sender_name') . '</person_name>
                           <!--Optional:-->
                           <phone>' . $this->config->get('omnivalt_sender_phone') . '</phone>
                           <address postcode="' . $this->config->get('omnivalt_sender_postcode') . '" deliverypoint="' . $this->config->get('omnivalt_sender_city') . '" country="' . $this->config->get('omnivalt_sender_country_code') . '" street="' . $this->config->get('omnivalt_sender_address') . '" />
                        </returnAddressee>
                    <onloadAddressee>
                        <person_name>' . $this->config->get('omnivalt_sender_name') . '</person_name>
                        <!--Optional:-->
                        <phone>' . $this->config->get('omnivalt_sender_phone') . '</phone>
                        <address postcode="' . $this->config->get('omnivalt_sender_postcode') . '" deliverypoint="' . $this->config->get('omnivalt_sender_city') . '" country="' . $this->config->get('omnivalt_sender_country_code') . '" street="' . $this->config->get('omnivalt_sender_address') . '" />
                       <pick_up_time start="' . date("c", strtotime($pickDay . ' ' . $pickStart)) . '" finish="' . date("c", strtotime($pickDay . ' ' . $pickFinish)) . '"/>
                     </onloadAddressee>
                     </item>
                  </item_list>
               </interchange>
            </xsd:businessToClientMsgRequest>
         </soapenv:Body>
      </soapenv:Envelope>';
        $response = self::api_request($xmlRequest);
        if ($response['status']) {
            return $this->response->setOutput('got_request');
        } else {
            return $this->response->setOutput(json_encode('got_false'));
        }

    }
    private function api_request($request)
    {
        $barcodes = array();
        $errors = array();
        $url = $this->config->get('omnivalt_url') . '/epmx/services/messagesService.wsdl';

        $headers = array(
            "Content-type: text/xml;charset=\"utf-8\"",
            "Accept: text/xml",
            "Cache-Control: no-cache",
            "Pragma: no-cache",
            "Content-length: " . strlen($request),
        );
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_HEADER, 0);
        curl_setopt($ch, CURLOPT_USERPWD, $this->config->get('omnivalt_user') . ":" . $this->config->get('omnivalt_password'));
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $request);
        curl_setopt($ch, CURLOPT_TIMEOUT, 30);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        $xmlResponse = curl_exec($ch);

        if ($xmlResponse === false) {
            $errors[] = curl_error($ch);
        } else {
            $errorTitle = '';
            if (strlen(trim($xmlResponse)) > 0) {
                $search = array('SOAP-ENV:', 'SOAP:');
                $xmlResponse = str_ireplace($search, '', $xmlResponse);
                $xml = simplexml_load_string($xmlResponse);
                if (!is_object($xml)) {
                    $errors[] = 'Response is in the wrong format';
                }
                if (is_object($xml) && is_object($xml->Body->businessToClientMsgResponse->faultyPacketInfo->barcodeInfo)) {
                    foreach ($xml->Body->businessToClientMsgResponse->faultyPacketInfo->barcodeInfo as $this->data) {
                        $errors[] = $this->data->clientItemId . ' - ' . $this->data->barcode . ' - ' . $this->data->message;
                    }
                }
                if (empty($errors)) {
                    if (is_object($xml) && is_object($xml->Body->businessToClientMsgResponse->savedPacketInfo->barcodeInfo)) {
                        foreach ($xml->Body->businessToClientMsgResponse->savedPacketInfo->barcodeInfo as $this->data) {
                            $barcodes[] = (string) $this->data->barcode;
                        }
                    }
                }

            }
        }
        if (!empty($errors)) {
            return array('status' => false, 'msg' => implode('. ', $errors));
        } else {
            if (!empty($barcodes)) {
                return array('status' => true, 'barcodes' => $barcodes);
            }

            $errors[] = 'No saved barcodes received';
            return array('status' => false, 'msg' => implode('. ', $errors));
        }
    }

}
