$('#rules-area').html('<%=j render partial: "rules/rules_list", locals: { show: @show, rule: @rule } %>');
$('#rules-notice').html('<span class="alert alert-danger">Rule destroyed.</span>')