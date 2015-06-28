displayItem = (item,lan)->
	lan ?= 'en'
	holder = $('<div/>',{id:'destinyArmory'+item,'class':'destinyArmoryHolder'})
	$.get 'http://floresbenavides.com:8080/'+item+'/'+lan, (html)->
		holder.html html
		$('body').append holder
		return
	return

offsetY = 0
offsetX = 0
positionItem = (item)->
	offsetY+= offscreenY(item)
	offsetX+= offscreenX(item)
	item.css({
		transform:'translate('+offsetX+'%,'+offsetY+'%)'
	})
	if offscreenY(item) isnt 0 or offscreenY(item) isnt 0
		positionItem(item)


hideItem = (item)->
	$('#destinyArmory'+item).remove()
	return

offscreenY = (el) ->
	if el.offset()
		
		top = el.offset().top
		bottom = el.offset().top + el.height()
		maxH = $(window).height()
		minH = 0

		if top <= minH and bottom > maxH
			return 0
		else if top >= minH and bottom <= maxH
			return 0
		else if top <= minH
			return 1
		else
			return -1

	else
		return 0

offscreenX = (el) ->
	if el.offset()
		
		left = el.offset().left
		right = el.offset().left + el.width()
		maxW = $(window).width()
		minW = 0

		if left <= minW and right > maxW
			return 0
		else if left >= minW and right <= maxW
			return 0
		else if left <= minW
			return 110
		else
			return -110

	else
		return 0

$(document).ready ->

	$('.destinyArmory').hover(
		->
			displayItem($(this).data('item'),$(this).data('lan'))
			$(this).mousemove (event)->
				handler = '#destinyArmory'+$(this).data('item')
				$(handler).css({
					left:event.pageX+20,
					top:event.pageY+10
				})
				positionItem $(handler)
				$(handler).show()
		-> hideItem($(this).data('item'))
	)