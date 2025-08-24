// Import and register all your controllers from the importmap under controllers/**/*_controller
import { application } from "controllers/application"

console.log('🎯 Controllers index loaded')
console.log('🎯 Application instance:', application)

// Explicitly import and register the header controller
import HeaderController from "./header_controller"
console.log('🎯 HeaderController imported:', HeaderController)
application.register("header", HeaderController)
console.log('🎯 Header controller registered')

// Lazy load controllers as they appear in the DOM (remember not to preload controllers in import map!)
// import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
// lazyLoadControllersFrom("controllers", application) ;
