# mint-codemirror
This package provides a component for the [CodeMirror](https://codemirror.net) code editor to be used in Mint projects.

## Installation
To use the component just add this to the `dependencies` field of the projects 
`mint.json` file.

```
"mint-codemirror": {
  "repository": "https://github.com/mint-lang/mint-codemirror",
  "constraint": "1.0.0 <= v < 2.0.0"
}
```

## Usage
To get the basic component without any modes and the default theme, just add the component to your render function:

```
component Main {
  fun onChange (value : String) : Void {
    do {
      Debug.log(value)
    }
  }

  fun render : Html {
    <CodeMirror onChange={onChange}/>
  }
}
```

## Properties
The following properties are available:
* `javaScripts : Array(String)` - URLs for the JavaScript files that are needed for CodeMirror to work. This can come from a CDN or from local files. This should contian the base JavaScript and any other addons or modes that is required.
* `styles : Array(String)` - URLs for the CSS files that are that are needed for CodeMirror to work. This can come from a CDN or from local files. This should contain the base CSS and any other files for themes.
* `loadingContent : Html` - This is shown until the all the files have loaded and editor is ready.
* `onChange : Function(String, Void)` - This is called when the content changes.
* `value : String` - When provided this value will be in the editor.

## Advanced Usage
This is an example for using the all of the properties:
```
```
