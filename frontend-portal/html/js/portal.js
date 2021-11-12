function readyFn() {
    $.ajax({
        type: "POST",
        beforeSend: function (request) {
            request.setRequestHeader("Authorization", "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjEzMDA4MTkzODAsImlzcyI6Imp3dC5pbyIsInJvbGUiOiJjdXN0b21lcl9zdXBwb3J0Iiwic3ViIjoiSmFuZSBEb2UiLCJ1c2VySWQiOiIxMjM0Iiwicm9sZV9sZXZlbCI6IjIifQ.TLb16PIk9TwUySf8ieGd5OGlehBkvUVX_XDCOOpd_zY");
        },
        url: "http://localhost:8080/entitlements",
        success: entitlementsReady
    })
}

function entitlementsReady(data) {
    if (!data.entitlements['account/status']) {
        $("#account-status").remove()
    }
}

$(readyFn)

