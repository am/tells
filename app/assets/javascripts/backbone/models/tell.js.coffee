class ComplexresponseTells.Models.Tell extends Backbone.Model
  paramRoot: 'tell'

  defaults:
    name: null
    message: null
    published: null

class ComplexresponseTells.Collections.TellsCollection extends Backbone.Collection
  model: ComplexresponseTells.Models.Tell
  url: '/tells'
