<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>
<style>
.common-style {
  text-decoration: none;
  margin-left: 10px;
  cursor: pointer;
  background-color: transparent;
  border: none;
  outline: none;
  padding: 0;
  color: green;
}

input{
margin: 10px;
}
</style>
   <br><br><br><br><br><br><br>
 <div class="section-title">
          <h2> 로그인</h2>
        </div>
<div style="display: flex; flex-direction: column; align-items: center; justify-content: center; ">

    <h4 style="color: red">${error}</h4>
    <h4 style="color: red">${logout}</h4>
    
    <form role="form" action="/login" method="post">
        <div class="form-group">
            <div style="display: flex; align-items: center;">
                <label for="username" style="width: 70px; margin-right: 10px;">아이디</label>
                <input class="form-control" id="username" placeholder="ID" name="username" type="text" style="width: 150px;" value="kimnara" autofocus>
                <input type ="button" id="findIdBtn" class="common-style" value="회원 아이디찾기">
                <a href="/genStaff/findId" class="common-style" style="color: skyblue;">병원관계자 아이디 찾기</a>
            </div>
        </div>
        <div class="form-group">
            <div style="display: flex; align-items: center;">
                <label for="password" style="width: 70px; margin-right: 10px;">비밀번호</label>
                <input class="form-control" id="password" placeholder="Password" name="password" type="password" style="width: 150px;" value="asdf1234$">
                <input type="button" id="findPasswordBtn" class="common-style" value="회원 비밀번호 찾기">
                <a href="/genStaff/findPw"  class="common-style" style="color: skyblue;">병원관계자 비밀번호 찾기</a>
            </div>
        </div>
<!--         <div class="checkbox"> -->
<!--             <label> -->
<!--                 <input name="remember-me" type="checkbox">Remember Me -->
<!--             </label> -->
<!--         </div> -->
        <input type="submit" value="Login" class="btn btn-lg btn-success btn-block">
        <a href="/" class="btn btn-lg btn-info btn-block">홈페이지</a>

        <input type="hidden" name="${_csrf.parameterName}" value= "${_csrf.token}">
    </form>
</div>
  <!-- Modal 게시물 등록 완료 시 표시 -->
				<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
					aria-labelledby="myModalLabel" aria-hidden="true">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal"
									aria-hidden="true">&times;</button>
								<h4 class="modal-title" id="myModalLabel">MESSAGE</h4>
							</div>
							<div class="modal-body">처리가 완료되었습니다.</div>
							<div class="modal-footer">
								  <button type="button" class="btn btn-default close" data-dismiss="modal">닫기</button>
					
							</div>
						</div>
						<!-- /.modal-content -->
					</div>
					<!-- /.modal-dialog -->
				</div>
				<!-- /.modal -->
				<!-- ID Recovery Modal -->
<div id="idRecoveryModal" class="modal">
  <div class="modal-content" style="width: 30%; margin: 100px auto;">
    <span class="close2" style="position: absolute; top: 10px; right: 10px; font-size: 24px;">&times;</span>
    FIND ID
    <form id="idRecoveryForm" style="padding: 20px;">
        <div style="margin-bottom: 10px;">
            <input type="text" placeholder="NAME" name="name" id="name" required>
        </div>
        <div style="margin-bottom: 10px;">
            <input type="text" placeholder="PHONE" pattern="\d{11}" name="phone" id="phone" placeholder="01012345678" required>
        </div>
        <br>
        <input type="button" value="Find ID" id="findBtn" onclick="findId()">
    </form>
    <!-- Display the result here -->
    <p id="result" style="text-align: center;"></p>
    <!-- Confirm button -->
   <input type="button" value="OK" onclick="confirmId()" style="width: 100%; display: none;" id="confirmButton">
 
</div>
</div>
<script>

$(document).ready(function() {
    //on login button click
    $('input[type=submit][value=login]').click(function(e) {

        //Prevent the form from submitting (default action)
        e.preventDefault();

        var usernameFieldEmpty = !$('input[name=username]').val();
        var passwordFieldEmpty = !$('input[name=password]').val();

         if(usernameFieldEmpty || passwordFieldEmpty) { 
            // If any field is empty, display an error message and stop here
            $('#error').text('Please fill in all fields.').css('color', 'red');
            return;
         }

         this.form.submit();  // If both fields are filled, submit the form

      });
});

$(document).ready(function() {
    
     //on form submit
     $('#findBtn').click(function(e) {

        //Prevent the form from submitting (default action)
        e.preventDefault();

         //validate fields and show error messages if empty or invalid
         var nameFieldEmpty = !$('#name').val();
         var emailFieldEmptyOrInvalid = !$('#email').val() || !/^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)?$/i.test($('#email').val());

         $('#errorName').toggle(nameFieldEmpty);
         $('#errorEmail').toggle(emailFieldEmptyOrInvalid);

          if (!nameFieldEmpty && !emailFieldEmptyOrInvalid) { // If both fields are valid, submit the form
            this.submit();
          } 

      });
});

// Open the modal
$('#findIdBtn').click(function(event){
  var modal = document.getElementById('idRecoveryModal');
  modal.style.display = "block";
});

// Close the modal
var span = document.getElementsByClassName("close2")[0];
span.onclick = function() {
  var modals = document.getElementsByClassName("modal");
  for (var i = 0; i < modals.length; i++) {
    modals[i].style.display = "none";
  }
};

// Send AJAX request to find ID
function findId() {
    var csrfHeaderName = "${_csrf.headerName}";
    var csrfTokenValue = "${_csrf.token}";
    var name = $('#name').val();
    var phone = $('#phone').val();

    $.ajax({
        url: '/member/findId',
        dataType : 'text',
        method: 'POST',
        data: { "name" : name, "phone": phone },
        beforeSend: function(xhr) {
            xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
        },
        success: function(data) {
                $('#result').css('color', 'black').text("아이디는 : " + data + " 입니다.");
                $('#confirmButton').show();
        },
        error:function(request,status,error){
            $('#result').css('color', 'red').text("ID가 존재하지 않습니다.");
            $('#confirmButton').hide();
        }
      });
}
//Confirm the found ID and close the modal
function confirmId() {
	var modals = document.getElementsByClassName("modal");
	for (var i = 0; i < modals.length; i++) {
		modals[i].style.display = "none";
	}
	var foundIdText = $("#result").text();
	var foundId = foundIdText.substring(foundIdText.indexOf(':') + 2, foundIdText.indexOf(' 입니다.'));
	if(foundId) { // if an ID was found
		$("input[name=username]").val(foundId); // fill in the login form with it
	}
}

$('#findPasswordBtn').click(function(){
	   window.location.href='/member/findpsw';
});
</script>
<script>
var newPw = '${newPw}';
if(newPw !== null && newPw !== ''){
	swal(newPw, {icon:'success'});
}
$(function() {
//게시물 처리 결과 알림 모달창 처리 -------------------
var result = '${foundId}';
checkModal(result);


//모달 창 재출력 방지
history.replaceState({}, null, null); //history 초기화

function checkModal(result) {
	//result 값이 있는 경우에 모달 창 표시
	if (result === '' || history.state) {
		return;
	}

	if (result !== null) { //게시물이 등록된 경우
		$('.modal-body').html("아이디는 "+ result + '입니다.');
		console.log(result);
	}

	$('#myModal').modal('show');
}

//END 게시물 처리 결과 알림 모달창 처리
});
$(".close").on("click", function(){
	$('#myModal').modal('hide');
});
</script>

</body>
<%@ include file="/WEB-INF/views/includes/footer.jsp" %>
