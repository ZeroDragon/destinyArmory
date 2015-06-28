destinyAjax = false
displayItem = (item,lan)->
	lan ?= 'en'
	holder = $('<div/>',{id:'destinyArmory'+item,'class':'destinyArmoryHolder'})
	holder.html('')
	destinyAjax = $.get 'http://floresbenavides.com:8080/'+item+'/'+lan, (html)->
		holder.html html
		$('body').append holder
		return
	return

hideItem = (item)->
	destinyAjax.abort()
	$('#destinyArmory'+item).html('')
	$('#destinyArmory'+item).remove()
	return

$(document).ready ->
	$('.destinyArmory')
		.hover(
			->
				displayItem($(this).data('item'),$(this).data('lan'))
				$(this).mousemove (event)->
					handler = '#destinyArmory'+$(this).data('item')
					cursorY = ~~(((event.pageY-$(window).scrollTop())*100)/$(window).height())+2
					cursorX = ~~(((event.pageX-$(window).scrollLeft())*100)/$(window).width())
					offsetX = 0
					offsetX = -110 if cursorX > 50
					$(handler).css({
						left:event.pageX+20-$(window).scrollLeft(),
						top:event.pageY+10-$(window).scrollTop()
						transform:'translate('+(offsetX)+'%,'+(-1*cursorY)+'%)'
					})
					$(handler).show()
			-> hideItem($(this).data('item'))
		)