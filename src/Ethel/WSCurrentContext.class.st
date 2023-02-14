"
Holds an instance of `WSContext` during request execution.

At any stage during request execution you can get to the current context via `#value`. The context contains the transport and endpoints objects.
"
Class {
	#name : #WSCurrentContext,
	#superclass : #DynamicVariable,
	#category : #'Ethel-Core'
}
