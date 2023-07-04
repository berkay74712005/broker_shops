var currentItems = null;
var currentCategory = null;
var currentCart = {};

window.addEventListener("message", function(event) {
    let data = event.data;
    switch (data.value) {
        case 'openShop_broker':
            currentItems = JSON.parse(data.items);
            var firstCategory = true;
            $('.shops_category_box').remove();
            $('.shops_items_box').remove();
            $('.shops_cart_box').remove();
            $('.broker_shop_container').css('display', 'block');
            $.each(JSON.parse(data.categories), function(index, value) {
                var selectedClass = '';
                if (firstCategory == true) {
                    firstCategory = false;
                    $('.shops_items_header').text(value);
                    selectedClass = 'shops_category_box_selected';
                    currentCategory = index;
                } else {
                    selectedClass = '';
                };
                $('#shops_categories').append(`
                    <div class="shops_category_box ${selectedClass}" data-categoryname='${index}' data-categorylabel='${value}' onclick='switchCategory(this)'>
                        <div class="shops_category_text">
                            <span>${value}</span>
                        </div>
                    </div>`);
            });
            $.each(currentItems, function(index, value) {
                var showItemData = 'style="display: none;"';
                if (currentCategory == value.category) {
                    showItemData = 'style="display: block;"';
                };
                $('.shops_items_layout').append(`
                    <div class="shops_items_box" ${showItemData} data-category='${value.category}' data-item='${value.item}' data-type='${value.type}'>
                        <div class="shops_items_image_box">
                            <img class="shops_items_image" src="${value.img}">
                        </div>
                        <div class="shops_items_name_box">
                            <p class="shops_items_label">${value.label}</p>
                        </div>
                        <div class="shops_items_price_box">
                            <span class="shops_items_price">Price:</span>
                            <span class="shops_items_price_tag">${value.price}$</span>
                        </div>
                        <div class="shops_items_buy_btn" onclick='addItemToCart(this)'>
                            <span>Add to cart</span>
                        </div>
                    </div>`);
            });

            break;
        default:
            break;
    };
});

function switchCategory(elem) {
    var newCategory = $(elem).data('categoryname');
    var newCategorylabel = $(elem).data('categorylabel');
    if (newCategory != currentCategory) {
        currentCategory = newCategory;
        $('.shops_category_box_selected').removeClass('shops_category_box_selected');
        $(elem).addClass('shops_category_box_selected');
        $('.shops_items_header').text(newCategorylabel);
        $(".shops_items_box").each(function(index) {
            var currentDiv = $(this)
            var itemCategory = currentDiv.data('category');
            if (itemCategory == currentCategory) {
                currentDiv.css('display', 'block');
            } else {
                currentDiv.css('display', 'none');
            };
        });
    };
};

function addItemToCart(elem) {
    var itemDiv = $(elem);
    var parentData = itemDiv.parent();
    var itemName = parentData.data('item');
    var itemType = parentData.data('type');
    var itemPrice = JSON.parse(parentData.children().find('.shops_items_price_tag').text().replace('$', ''));
    if (currentCart[itemName] != undefined) {
        var oldPrice = currentCart[itemName].price;
        var oldCount = currentCart[itemName].count;
        currentCart[itemName] = { count: oldCount + 1, price: oldPrice + itemPrice };
        $(".shops_cart_box").each(function(index) {
            var cdivx = $(this);
            var divItemData = cdivx.data('item');
            if (divItemData == itemName) {
                cdivx.children().find('.shops_items_cart_price_tag').text(currentCart[itemName].price);
                cdivx.children().find('.shops_cart_actions_count').text(currentCart[itemName].count);
                return false;
            };
        });
    } else {
        currentCart[itemName] = { count: 1, price: itemPrice, type: itemType };
        $('.shops_cart_layout').append(`
            <div class="shops_cart_box" data-item='${itemName}'>
                <div class="shops_cart_image_box">
                    <img class="shops_cart_image" src="${parentData.children().find('.shops_items_image').attr('src')}">
                </div>
                <div class="shops_cart_name_box">
                    <br>
                    <span>${parentData.children().find('.shops_items_label').text()}</span>
                    <br>
                    <span class="shops_items_price">Price:</span>
                    <span class='shops_items_cart_price_tag'>${currentCart[itemName].price}$</span>
                </div>
                <br>
                <div class="shops_cart_actions_layout">
                    <span class="shops_cart_actions_minus" onclick='actionItemInCart("minus", this)'>-</span>
                    <span class="shops_cart_actions_count">${currentCart[itemName].count}</span>
                    <span class="shops_cart_actions_plus" onclick='actionItemInCart("plus", this)'>+</span>
                </div>
            </div>
        `);
    };
    var totalPrice = 0;
    $.each(currentCart, function(index, value) {
        totalPrice = totalPrice + value.price;
    });
    $('.shops_cart_totalPrice_price').text(totalPrice + '$');
};

function actionItemInCart(types, div) {
    var parentData = $(div).parent().parent();
    var itemName = parentData.data('item');
    var totalPrice = 0;
    $.each(currentCart, function(index, value) {
        if (value != undefined) {
            totalPrice = totalPrice + value.price;
        };
    });
    if (types == 'plus') {
        currentCart[itemName].price = (currentCart[itemName].price / currentCart[itemName].count) + currentCart[itemName].price;
        currentCart[itemName].count = currentCart[itemName].count + 1;
        var singelItemPrice = currentCart[itemName].price / currentCart[itemName].count;
        totalPrice = totalPrice + singelItemPrice;
        parentData.children().find('.shops_cart_actions_count').text(currentCart[itemName].count);
        parentData.children().find('.shops_items_cart_price_tag').text(currentCart[itemName].price);
    } else if (types == 'minus') {
        var singelItemPrice = currentCart[itemName].price / currentCart[itemName].count;
        currentCart[itemName].count = currentCart[itemName].count - 1;
        if (currentCart[itemName].count <= 0) {
            parentData.remove();
            currentCart[itemName] = undefined;
        } else {
            currentCart[itemName].price = currentCart[itemName].price - singelItemPrice;
            parentData.children().find('.shops_cart_actions_count').text(currentCart[itemName].count);
            parentData.children().find('.shops_items_cart_price_tag').text(currentCart[itemName].price);
        };
        totalPrice = totalPrice - singelItemPrice;
    };
    $('.shops_cart_totalPrice_price').text(totalPrice + '$');
};

function buyCartShop(type) {
    $.post(`http:///${GetParentResourceName()}/buyItems_brokerShops`, JSON.stringify({
        items: currentCart,
        paytype: type
    }));
    CloseBrokerShops();
};

$(document).keyup(function(e) {
    if (e.key === "Escape") {
        CloseBrokerShops();
    };
});

function CloseBrokerShops() {
    $.post(`http:///${GetParentResourceName()}/close_brokerShops`, JSON.stringify({}));
    currentItems = null;
    currentCategory = null;
    currentCart = {};
    $('.broker_shop_container').css('display', 'none');
};