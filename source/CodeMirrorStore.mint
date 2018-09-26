store CodeMirror.Store {
   state editors : Array(EditorRecord) = []

   fun addEditor(nameNew : String, editorNew : Unit) : Promise(Never, Void) {
      next {
         editors = Array.push({ name = nameNew, editor = editorNew }, editors)
      }
   }

   fun getEditor(name : String) : EditorRecord {
      Array.firstWithDefault({name = "", editor=`{}`},Array.select((thing : EditorRecord) : Bool => {
         if(thing.name == name) {
            true
         } else {
            false
         }
      }, editors))
   }

   fun listSelections(editor : EditorRecord) : Array(EditorSelections) {
      `editor.editor.listSelections()`
   }

   fun setSelections(editor : EditorRecord, selections : Array(EditorSelections)) : Void {
      `editor.editor.setSelections(selections)`
   }

   fun setValue(editor : EditorRecord, text : String) : Void {
      `editor.editor.setValue(text)`
   }

   fun getSelection(editor : EditorRecord) : String {
      `editor.editor.getDoc().getSelection()`
   }

   fun saveSelection(editor: EditorRecord, text : String) : Void {
      `editor.editor.getDoc().replaceSelection(text)`
   }

   fun insertAtCursor(editor : EditorRecord, text : String) : Void {
      `(()=>{
         var cursor = editor.editor.getDoc().getCursor();
         editor.editor.getDoc().replaceRange(text,cursor);
      })()`
   }

   fun getCursor(editor : EditorRecord) : Cursor {
      `editor.editor.getDoc().getCursor()`
   }

   fun setCursor(editor : EditorRecord, cursor : Cursor) : Void {
      `editor.editor.getDoc().setCursor(cursor)`
   }

   fun isSelection(editor : EditorRecord) : Bool {
      `editor.editor.getDoc().somethingSelected()`
   }
}

record EditorRecord {
   name : String,
   editor : Unit
}

record Cursor {
   line : Number,
   ch : Number
}

record EditorSelections {
   anchor : Cursor,
   head : Cursor
}