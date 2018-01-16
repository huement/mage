//"hyperterm-base16-tomorrow-night",
// "foregroundColor": "#fefefe",
// "backgroundColor": "#0f0f0f",
// "borderColor": "#0f0f0f",
// hyper-material-vibrancy
//     "hyperline",
module.exports = {
  "config": {
    "fontSize": 14,
    "fontFamily": "Hack, Menlo, DejaVu Sans Mono, Consolas, Lucida Console, monospace",
    "css": "",
    "termCSS": "",
    "showHamburgerMenu": "",
    "showWindowControls": "",
    "padding": "32px 20px 30px 20px",
    "shell": "",
    "shellArgs": [
      "--login"
    ],
	  "hyperline": {
	    "color": "black",
	    "plugins": [
	      {
	        "name": "hostname",
	        "options": {
	          "color": "lightBlue"
	        }
	      },
	      {
	        "name": "memory",
	        "options": {
	          "color": "white"
	        }
	      },
	      {
	        "name": "uptime",
	        "options": {
	          "color": "lightYellow"
	        }
	      },
	      {
	        "name": "cpu",
	        "options": {
	          "colors": {
	            "high": "lightRed",
	            "moderate": "lightYellow",
	            "low": "lightGreen"
	          }
	        }
	      },
	      {
	        "name": "network",
	        "options": {
	          "color": "lightCyan"
	        }
	      },
	      {
	        "name": "battery",
	        "options": {
	          "colors": {
	            "fine": "lightGreen",
	            "critical": "lightRed"
	          }
	        }
	      }
	    ]
	  },
    "hyperTransparentDynamic": {
      "alpha": 0.7 // default 50%
    },
    "env": {},
    "bell": false,
    "copyOnSelect": false
  },
  "plugins": [
    "hyperterm-alternatescroll",
    "hyper-blink",
    "hyper-dark-scrollbar",
    "hyperterm-paste",
    "hyper-autohide-tabs",
    "hyper-hide-title"
  ],
  "localPlugins": [
    'hyperterm-material-dark',
    "hyper-transparent-dynamic"
  ]
};
