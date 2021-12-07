function readyFn() {
    $.ajax({
        type: "GET",
        url: "/entitlements",
        success: entitlementsReady,
        error: entitlementsCallError
    })
}

function entitlementsReady(data) {
    if (!data.includes('account/status')) {
        $("#account-status").show()
    }
    if (!data.includes('account/transactions')) {
        $("#account-transactions").show()
    }
    if (!data.includes('account/modify')) {
        $("#account-modify").show()
    }
}

function entitlementsCallError(data) {
   $("#error").show();
   $("#error .error-text").text("Failed to load entitlements (" + data.statusText + " [" + data.status + "])");
}

$(readyFn)

