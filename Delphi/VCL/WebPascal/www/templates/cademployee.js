function loadCountry(avalue, aform){
   var aurl = './index?dwmark:dwcbpaises';
   $.ajax(
                {
                   type: "post",
                   url: aurl,
                   contentType: false,
                   headers     : {"Authorization": "Bearer "  + window.sessionStorage.getItem('token')},
                   contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                   success: function (data) {
					                         $select = $('#JOB_COUNTRY'+aform);
											 $.each(data, function(key, value) {
																				var i = value.UF;
																				var b = value.COUNTRY;
																			    if (avalue == i) {
                                                                                 $select.append( $("<option value=" + i + " selected>" + b + "</option>"));
                                                                                }
                                                                                else {
                                                                                  $select.append( $("<option value=" + i + ">" + b + "</option>"));
                                                                                 }
																				});
                   },
                   error: function(result) {
                             swal.fire("Atenção", "Erro na autenticação.", "warning");
                   }
                   });
}


function loaddatatable(){
var datatable = $('#my-table').DataTable({ //dataTable também funcionar
                retrieve: true,
                dom: "Bfrtip", // Use dom: 'Blfrtip', para fazer o seletor "por página" aparecer.
                ajax: {
                    url: './index?dwmark:datatable',
                    contentType: false,
                    headers     : {"Authorization": "Bearer "  + window.sessionStorage.getItem('token')},
                    type: 'POST',
                    dataSrc: ''},
                stateSave: true,
                responsive: true,
                columns: [
                    {title: 'CODIGO', data: 'EMP_NO'},
                    {title: 'NOME', data: 'FIRST_NAME'},
                    {title: 'SOBRENOME', data: 'LAST_NAME'},
                    {title: 'TELEFONE', data: 'PHONE_EXT'},
                    {title: 'DATA', data: 'HIRE_DATE'},
                    {title: 'EMPREGO/PAIS', data: 'JOB_COUNTRY'},
                    {title: 'SALARIO', data: 'SALARY'},
                    {title: 'Ações', data: null, sortable: false, render: function (obj) {
				      return '<button type="button" class="btn btn-warning btn-xs" onclick="myActionE('+ obj.EMP_NO +')"><i class="far fa-edit"></i></button> ' +
                                '<button type="button" class="btn btn-danger btn-xs" onclick="myActionD(\'' + obj.EMP_NO + '\',\'' + obj.FIRST_NAME + ' ' + obj.LAST_NAME + '\')"><i class="far fa-trash-alt"></i></button>'; }}
                              ],
                 columnDefs: [
                     {"className": "text-center", "width": "20px", "targets": 0 },
                     {"width": "100px", "targets": 1 },
                     {"width": "100px", "targets": 2 },
                     {"className": "text-center", "width": "30px", "targets": 3},
                     {"width": "70px", "targets": 4 },
                     {"className": "text-center", "width": "70px", "targets": 5 },
                     {"className": "text-right", "width": "50px", "targets": 6 },
                     {"className": "text-right", "width": "70px", "targets": 7 }
                                       ],
                 <!-- initComplete: function () {$( document ).on("click", "tr[role='row']", function(){myActionE($(this).children('td:first-child').text())});} -->
            });
 console.log(datatable);
 reloadDatatable(true);
}

function loadJobs(avalue, aform){
   var aurl =  './index?dwmark:dwcbcargos';
   $.ajax(
                {
                   type: "post",
                   url: aurl,
                   contentType: false,
                   headers     : {"Authorization": "Bearer "  + window.sessionStorage.getItem('token')},
                   contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                   success: function (data) {
					                         $select = $('#JOB_GRADE'+aform);
											 $.each(data, function(key, value) {
																				var i = value.JOB_GRADE;
																				var b = value.JOB_TITLE;
																			    if (avalue == i) {
                                                                                 $select.append( $("<option value=" + i + " selected>" + b + "</option>"));
                                                                                }
                                                                                else {
                                                                                  $select.append( $("<option value=" + i + ">" + b + "</option>"));
                                                                                 }
																				});
                   },
                   error: function(result) {
                             swal.fire("Atenção", "Erro na autenticação.", "warning");
                   }
                   });
}

function carcanewemployee(){
	   clearTimeout(myVar);
	   $("#FIRST_NAME").val('');
       $("#LAST_NAME").val('');
       $("#PHONE_EXT").val('');
       $("#CAD_HIRE_DATEB").val('');
       $("#JOB_GRADE").val('');
	   loadJobs("", "");
       $("#JOB_COUNTRY").val('');
	   loadCountry("", "");
       $("#SALARY").val('');
       $('.operacao').val('insert');
}	

function newEmployee(){
	   loadEmployee();
       myVar = setTimeout(carcanewemployee, 500);
};
 
function loadEmployee(){
 MyHtml("cademployee");
};
 
function cancelemployee(){
  reloadDatatable(true);
};

function canceldelete(){
    $('#modal_apagar').modal('hide');
};

function myActionD(id, name){
      $('#nome_empregado').html(name);
      $('#ok').attr('idd', id);     
      $('#modal_apagar').modal('show');     
};

function deleteemployee(){
	 var idd = $('#ok').attr("idd");
     $.ajax(
                {
                    type: "post",
                    contentType: false,                    
                    headers     : {"Authorization": "Bearer "  + window.sessionStorage.getItem('token')},
                    url: './index?dwmark:operation&id=' + idd + '&operation=delete',
                    success: function (data) {
                        if (data) {
                            $('#modal_apagar').modal('hide');
                            reloadDatatable();
                            reloadDatatable(true);
                        } else {
                                 swal.fire("Erro...", "Não foi possível excluir o registro", "error");                            
                        }
                    }
     });
};

function saveemployee(){
    var id = getCookie("tempID");
    var sendInfo = {
                             FIRST_NAME: $("#FIRST_NAME").val(),
                             LAST_NAME: $("#LAST_NAME").val(),
                             PHONE_EXT: $("#PHONE_EXT").val(),
                             HIRE_DATE: $("#CAD_HIRE_DATEB").val(),
                              JOB_GRADE: $("#JOB_GRADE").val(),
                              JOB_COUNTRY: $("#JOB_COUNTRY").val(),
                              SALARY: $("#SALARY").val(),
                              OPERATION:  $('.operacao').val() 
                             };
       $.ajax({
           type: "POST",
           url: './index?dwmark:operation&id='+id,
           contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
           dataType: "json",
           headers     : {"Authorization": "Bearer "  + window.sessionStorage.getItem('token')},
		   data: sendInfo,
           success: function (msg) {
                    if (msg) {
                         if($('.operacao').val('edit') == 'edit'){
                           swal.fire("Sucesso", "Empregado editado com sucesso", "warning");                               
                         }else{
                           swal.fire("Sucesso", "Cadastro realizado com sucesso", "warning");
                         }
                    reloadDatatable();
                    reloadDatatable(true);
                   }
                 else {
                           swal.fire("Erro...", "Não foi possível finalizar a operação", "error");
               }
		   }});
};