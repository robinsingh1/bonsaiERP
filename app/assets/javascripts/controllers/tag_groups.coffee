myApp.controller('TagGroupsController', ($scope, $window, $http) ->
  $scope.tags = $window.bonsai.tags
  $scope.selected_tags = []
  $scope.edit = false


  # Start set for edit
  if $window.tag_group and $window.tag_group.id
    $scope.edit = true
    $scope.id = $window.tag_group.id
    $scope.name = $window.tag_group.name


    $scope.selected_tags = _.where($scope.tags, (tag) ->
      _.include($window.tag_group.tag_ids, tag.id)
    )

    _.each($scope.tags, (tag) ->
      if _.include($window.tag_group.tag_ids, tag.id)
        tag.hide = true
    )

  # End of set for edit

  $scope.color = Plugins.Tag.textColor

  #
  $scope.select = (tg) ->
    $scope.selected_tags.push(tg)
    tg.hide = true

  #
  $scope.remove = (t, index) ->
    $scope.selected_tags.splice(index, 1)
    tag = _.find($scope.tags, (tg) -> t.id is tg.id)

    tag.hide = false

  tagIds = ->
    _.map($scope.selected_tags, (tag) -> tag.id )

  getData = ->
    {
      name: $scope.name,
      tag_ids: tagIds()
    }

  create = ->
    $http.post('/tag_groups', { tag_group: getData()})
    .success( (resp) ->
      console.log(resp)
      alert('yes')
    )
    .error( (resp) ->
      console.log(resp)
      alert('Error')
    )

  #
  update = ->
    $http.put("/tag_groups/#{$scope.id}", { tag_group: getData()})
    .success( (resp) ->
      console.log(resp)
      alert('yes')
    )
    .error( (resp) ->
      console.log(resp)
      alert('Error')
    )

  #
  $scope.save = ->
    if $scope.edit
      update()
    else
      create()

)