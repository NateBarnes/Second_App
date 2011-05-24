// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function countdownChars() {
  var postField = document.getElementById("micropost_content");
  var labelField = document.getElementById("countdownLabel");
  labelField.innerHTML = (140-postField.value.length) + " characters remaining";
}