# mint-codemirror
This package provides a component for the [CodeMirror](https://codemirror.net) code editor to be used in Mint projects.

## Installation
To use the component just add this to the `dependencies` field of the projects
`mint.json` file.

```
"mint-codemirror": {
  "repository": "https://github.com/mint-lang/mint-codemirror",
  "constraint": "5.0.0 <= v < 6.0.0"
}
```

## Usage
To get the basic component without any modes and the default theme, just add the component to your render function:

```
component Main {
  fun onChange (value : String) : Promise(Never, String) {
    sequence {
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

<table>
  <tr>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
  </tr>
  <tr>
    <td>
      <code>javascripts</code>
    </td>
    <td>
      <code>Array(String)</code>
    </td>
    <td>
      URLs for the JavaScript files that are needed for CodeMirror to work.
      This can come from a CDN or from local files. This should contain the
      base JavaScript and any other addons or modes that is required.
    </td>
  </tr>
  <tr>
    <td>
      <code>styles</code>
    </td>
    <td>
      <code>Array(String)</code>
    </td>
    <td>
      URLs for the CSS files that are that are needed for CodeMirror to work.
      This can come from a CDN or from local files. This should contain the
      base CSS and any other files for themes.
    </td>
  </tr>
  <tr>
    <td>
      <code>onChange</code>
    </td>
    <td style="white-space: nowrap;">
      <code>Function(String, a)</code>
    </td>
    <td>
      This is called when the content changes.
    </td>
  </tr>
  <tr>
    <td>
      <code>loadingContent</code>
    </td>
    <td>
      <code>Html</code>
    </td>
    <td>
      This is shown until the all the files have loaded and editor is ready.
    </td>
  </tr>
  <tr>
    <td>
      <code>lineNumbers</code>
    </td>
    <td>
      <code>Bool</code>
    </td>
    <td>
      Whether or not show line numbers.
    </td>
  </tr>
  <tr>
    <td>
      <code>value</code>
    </td>
    <td>
      <code>Bool</code>
    </td>
    <td>
      When provided this value will be in the editor.
    </td>
  </tr>
  <tr>
    <td>
      <code>theme</code>
    </td>
    <td>
      <code>String</code>
    </td>
    <td>
      The theme of the editor.
    </td>
  </tr>
  <tr>
    <td>
      <code>mode</code>
    </td>
    <td>
      <code>String</code>
    </td>
    <td>
      The mode of the editor.
    </td>
  </tr>
</table>

## Advanced Usage
This is an example for using the all of the properties:

```
component Main {
  state value : String = "def print\n  puts 'Hello World!'\nend"

  fun onChange (value : String) : Promise(Never, Void) {
    next { value = value }
  }

  fun render : Html {
    <CodeMirror
      javascripts=[
        "https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.39.0/codemirror.min.js",
        "https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.39.0/mode/ruby/ruby.min.js"
      ]
      styles=[
        "https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.39.0/codemirror.min.css",
        "https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.39.0/theme/dracula.min.css"
      ]
      onChange={onChange}
      theme="dracula"
      value={value}
      mode="ruby"/>
  }
}
```

## License
MIT
