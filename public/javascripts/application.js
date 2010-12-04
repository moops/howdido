jQuery.ajaxSetup({ 'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")} })

function _ajax_request(url, data, callback, type, method) {
  if (jQuery.isFunction(data)) {
    callback = data;
    data = {};
  }
  return jQuery.ajax({
    type: method,
    url: url,
    data: data,
    success: callback,
    dataType: type
  });
}

jQuery.extend({
  put: function(url, data, callback, type) {
    return _ajax_request(url, data, callback, type, 'PUT');
  },
  delete_: function(url, data, callback, type) {
    return _ajax_request(url, data, callback, type, 'DELETE');
  }
});

jQuery.fn.submitWithAjax = function() {
  this.unbind('submit', false);
  this.submit(function() {
    jQuery.post(this.action, $(this).serialize(), null, "script");
    return false;
  })

  return this;
};

jQuery.fn.getWithAjax = function() {
  this.unbind('click', false);
  this.click(function() {
    jQuery.get($(this).attr("href"), $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

jQuery.fn.postWithAjax = function() {
  this.unbind('click', false);
  this.click(function() {
    jQuery.post($(this).attr("href"), $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

jQuery.fn.putWithAjax = function() {
  this.unbind('click', false);
  this.click(function() {
    jQuery.put($(this).attr("href"), $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

jQuery.fn.deleteWithAjax = function() {
  this.removeAttr('onclick');
  this.unbind('click', false);
  this.click(function() {
    jQuery.delete_($(this).attr("href"), $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

//This will "ajaxify" the links
function ajaxLinks(){
  jQuery('.ajaxForm').submitWithAjax();
  jQuery('a.get').getWithAjax();
  jQuery('a.post').postWithAjax();
  jQuery('a.put').putWithAjax();
  jQuery('a.delete').deleteWithAjax();
}

//build a form dialog
function buildFormDialog(name) {
  var f = jQuery('#' + name + '_form').dialog({ autoOpen: false, width: 600, title: name + ' form', modal: true, show: 'fade' });
  jQuery('.show_' + name + '_form').click(function() {
    f.dialog('open');
    return false;
  });
}

//validate a form
function validate(form_id) {
  jQuery('#' + form_id).validate({
        errorPlacement: function(error, element) {
          jQuery(element).attr('title', jQuery(error).html());
          jQuery(element).tooltip();
        }
  });
}

jQuery(document).ready(function() {

  //all non-GET requests will add the authenticity token in the data packet
  jQuery(document).ajaxSend(function(event, request, settings) {
    if (typeof(window.AUTH_TOKEN) == "undefined") return;
    // IE6 fix for http://dev.jquery.com/ticket/3155
    if (settings.type == 'GET' || settings.type == 'get') return;

    settings.data = settings.data || "";
    settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(window.AUTH_TOKEN);
  });

  ajaxLinks(); 
    
  jQuery("#lavaLamp").lavaLamp({ fx: "easeOutBack", speed: 700});
  jQuery("input.calendar").datepicker();
  jQuery("input.calendar").datepicker("option", "dateFormat", "yy-mm-dd");
  jQuery("input.today").datepicker('setDate', new Date());
  jQuery("table.vis").visualize();
  
});
