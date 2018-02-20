<?php
/*
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
        
        $numRows = $this->db->query("SELECT COUNT(*) 
                                        FROM ".DB_PREFIX."order
                                        WHERE shipping_code LIKE 'omnivalt%'
                                        ")->rows;
		if($numRows)								
			$numRows = intval($numRows[0]["COUNT(*)"]);
        $this->data['countRows'] = $numRows;

        if (isset($this->request->get['page'])) {
            $page = $this->request->get['page'];
         } else {
            $page = 1;
         }      
       
            $start = ($page - 1) * 50;
            $limit = 50;
         

        $pagination = new Pagination();
        $pagination->total = $numRows;
        $pagination->page = $page;
        $pagination->limit = $limit; 
        //$pagination->text = 'pagination';
        $pagination->url = $this->url->link('omnivalt/omnivalt', 'token=' . $this->session->data['token'] .'&page={page}', 'SSL');
      
        $this->data['pagination'] = $pagination->render();

        $orders = $this->db->query("SELECT order_id, total, date_modified, CONCAT(firstname, ' ', lastname) AS full_name, B.tracking, B.manifest, B.labels, B.id_order 
                                    FROM ".DB_PREFIX."order A
                                    LEFT JOIN ".DB_PREFIX."order_omniva B ON A.order_id = B.id_order
                                    WHERE shipping_code LIKE 'omnivalt%'
                                    ORDER BY manifest DESC
                                    LIMIT $start, $limit  
                                    ;");
        //var_dump($orders->rows);
        //print 'hello world';
        /*$this->data['header'] = $this->load->controller('common/header');
        $this->data['column_left'] = $this->load->controller('common/column_left');
        $this->data['footer'] = $this->load->controller('common/footer');*/

        $this->data['orders'] = $orders->rows;

		$this->data['breadcrumbs'] = array();

		$this->data['breadcrumbs'][] = array(
			'text' => $this->language->get('text_home'),
			'href' => $this->url->link('common/home', 'token=' . $this->session->data['token'], true),
      'separator' => false

		);

		$this->data['breadcrumbs'][] = array(
			'text' => $this->language->get('text_shipping'),
			'href' => $this->url->link('extension/shipping', 'token=' . $this->session->data['token'] . '&type=shipping', true),
      'separator' => false

		);
        $this->data['breadcrumbs'][] = array(
			'text' => $this->language->get('text_manifest'),
			'href' => $this->url->link('omnivalt/omnivalt', 'token=' . $this->session->data['token'], true),
      'separator' => false

		);
        $this->data['text_manifestHead'] = $this->language->get('text_manifestHead');
        $this->data['text_newManifest'] = $this->language->get('text_newManifest');
        $this->data['action'] = $this->url->link('omnivalt/omnivalt/newManifest', 'token=' . $this->session->data['token'], true);
        $this->data['button_cancel'] = $this->language->get('button_cancel');        
        $this->data['cancel'] = $this->url->link('common/home', 'token=' . $this->session->data['token'] . '&type=shipping', true);
        $this->data['client'] = $this->url->link('sale/order/info', 'token=' . $this->session->data['token'], true);
        $this->data['labels'] = $this->url->link('shipping/omnivalt/printDocs', 'token=' . $this->session->data['token'], true);
        $this->data['genLabels'] = $this->url->link('shipping/omnivalt/labels', 'token=' . $this->session->data['token'], true);
        $this->data['currentManifest'] = $this->config->get('omniva_manifest');
        $this->data['newManifest'] = 'Naujas Manifestas';
        //$this->newManifest();
    $this->template = 'omnivalt/omnivalt.tpl';

    		$this->children = array(
			'common/header',
			'common/footer'
		);        
    $this->response->setOutput($this->render());
        //$this->response->setOutput($this->load->view('omnivalt/omnivalt', $this->data));
    }
    
    public function newManifest()
    {
        $this->load->model('setting/setting');
        $manifest = $this->config->get('omniva_manifest');
        $manifest++;
        
        $this->model_setting_setting->editSetting('omniva', array('omniva_manifest' => $manifest));

        //$this->response->redirect($this->url->link('omnivalt/omnivalt', 'token=' . $this->session->data['token'], true));
                    $this->redirect($this->url->link('omnivalt/omnivalt', 'token=' . $this->session->data['token'], true));

        
    }

    public function oldManifest()
    {
        $this->request->get('manifest');

    }

}