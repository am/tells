class ComplexresponseTells.Models.Tell extends Backbone.Model
  paramRoot: 'tell'

  defaults:
    message: null

class ComplexresponseTells.Collections.TellsCollection extends Backbone.Collection
  model: ComplexresponseTells.Models.Tell
  url: '/tells'
