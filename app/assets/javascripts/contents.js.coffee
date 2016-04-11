# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# jQuery ->
#   isScrolledIntoView = (elem) ->
#     docViewTop = $(window).scrollTop()
#     docViewBottom = docViewTop + $(window).height()
#     elemTop = $(elem).offset().top
#     elemBottom = elemTop + $(elem).height()
#     (elemTop >= docViewTop) && (elemTop <= docViewBottom)

#   if $('.pagination').length
#     $(window).scroll ->
#       url = $('.pagination .next a').attr('href')
#       if url && isScrolledIntoView('.pagination')
#         $('.pagination').text("Fetching more posts...")
#         $.getScript(url)

#     $(window).scroll()
$(document).on "turbolinks:load", ->
  $(".contents.show").ready ->

    mapObject = $("#contentMap")
    if mapObject.length != 0
      console.log("Success Loading Contents show")
      console.log(mapObject)
      L.mapbox.accessToken = 'pk.eyJ1Ijoid2VzdmFuY2UiLCJhIjoiV3RpaE1xNCJ9.t3DpzGpN43q23tRcKMzLqQ';
      map = L.mapbox.map('contentMap', 'wesvance.n3ejgh0a', {
        zoomControl: false
        maxZoom: 14
      })

      map.touchZoom.disable();
      map.doubleClickZoom.disable();
      map.scrollWheelZoom.disable();
      map.attributionControl = false;

      # get JSON object
      # on success, parse it and
      # hand it over to MapBox for mapping
      # OLD WAY OF DOING IT?

      # $.ajax
      #   dataType: 'text'
      #   url: '/welcome/index.json'
      #   success: (data) ->
      #     geojson = $.parseJSON(data)
      #     map.featureLayer.setGeoJSON(geojson)

      $link = $('#contentMap').data('url')
      console.log($link)
      featureLayer = L.mapbox.featureLayer().loadURL($link).addTo(map);

      featureLayer.on 'ready', (e) ->
        map.fitBounds(featureLayer.getBounds(), {padding: [100,100]});

      # featureLayer.addTo(map);

      # add custom popups to each marker
      featureLayer.on 'layeradd', (e) ->
        marker = e.layer
        properties = marker.feature.properties

        # create custom popup
        popupContent =  '<div class="popup">' +
                        '<a href="' + properties.link + '">' +
                            '<h3>' + properties.name + '</h3>' +
                            '<p>'  + properties.body.substring(0,125) + "..." + '</p>' +
                            '</a>' +
                          '</div>'

        # http://leafletjs.com/reference.html#popup
        marker.bindPopup popupContent,
          closeButton: false
          minWidth: 200
          keepInView: true

      featureLayer.on 'click', (e) ->
        map.panTo(e.layer.getLatLng());
        e.layer.openPopup();

      featureLayer.on 'mouseover', (e) ->
        e.layer.openPopup();

$(document).on "turbolinks:load", ->
  $(".contents.edit").ready ->
    console.log("Success Loading Contents Edit")
    mapObject = $("#contentMapEdit")
    if mapObject.length != 0
      L.mapbox.accessToken = 'pk.eyJ1Ijoid2VzdmFuY2UiLCJhIjoiV3RpaE1xNCJ9.t3DpzGpN43q23tRcKMzLqQ';
      map = L.mapbox.map('contentMapEdit', 'wesvance.n3ejgh0a', {
        zoomControl: true
        maxZoom: 14
      })

      map.touchZoom.disable();
      map.doubleClickZoom.disable();
      map.scrollWheelZoom.disable();
      map.attributionControl = false;

      $link = $('#contentMapEdit').data('url')
      console.log($link)
      featureLayer = L.mapbox.featureLayer().loadURL($link).addTo(map);

      # marker = L.marker(new (L.LatLng)(37.9, -77),
      #   icon: L.mapbox.marker.icon('marker-color': 'ff8888')
      #   draggable: true)
      # marker.bindPopup 'This marker is draggable! Move it around.'
      # marker.addTo map

      featureLayer.on 'ready', (e) ->
        map.fitBounds(featureLayer.getBounds(), {padding: [100,100]});

      # featureLayer.addTo(map);

      # add custom popups to each marker
      featureLayer.on 'layeradd', (e) ->
        marker = e.layer
        properties = marker.feature.properties

        # create custom popup
        popupContent =  '<div class="popup">' +
                        '<a href="' + properties.link + '">' +
                            '<h3>' + properties.name + '</h3>' +
                            '<p>'  + properties.body.substring(0,125) + "..." + '</p>' +
                            '</a>' +
                          '</div>'

        # http://leafletjs.com/reference.html#popup
        marker.bindPopup popupContent,
          closeButton: false
          minWidth: 200
          keepInView: true

      featureLayer.on 'click', (e) ->
        map.panTo(e.layer.getLatLng());
        e.layer.openPopup();

      featureLayer.on 'mouseover', (e) ->
        e.layer.openPopup();

      selector = $('.datepicker')
      if selector != null
        selector.datepicker({
          autoSize: true
        })

$(document).on "turbolinks:load", ->
  $(".contents.new").ready ->
    selector = $('.datetimepicker')
    if selector != null
      selector.datetimepicker();


