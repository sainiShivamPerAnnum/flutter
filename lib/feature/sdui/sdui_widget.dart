import 'package:felloapp/util/stac/lib/stac.dart';
import 'package:flutter/material.dart';

class SduiLocalWidget extends StatelessWidget {
  const SduiLocalWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stac.fromJson(
          {
            "type": "baseScaffold",
            "showBackgroundGrid": false,
            "backgroundColor": "#1e1e21",
            "bottomNavigationBar": {
              "type": "column",
              "mainAxisSize": "min",
              "mainAxisAlignment": "end",
              "children": [
                {
                  "type": "container",
                  "color": "#232326",
                  "padding": {
                    "top": 18,
                    "left": 18,
                    "right": 18,
                    "bottom": 40,
                  },
                  "child": {
                    "type": "column",
                    "children": [
                      {
                        "type": "gestureDetector",
                        "onTap": {
                          "type": "action",
                          "actionType": "navigate",
                          "navigationStyle": "link",
                          "routeName": "/experts"
                        },
                        "child": {
                          "type": "container",
                          "height": 50,
                          "decoration": {
                            "color": "#FFFFFF",
                            "borderRadius": {
                              "topLeft": 8,
                              "topRight": 8,
                              "bottomLeft": 8,
                              "bottomRight": 8,
                            }
                          },
                          "child": {
                            "type": "center",
                            "child": {
                              "type": "text",
                              "data": "Talk to expert now",
                              "style": {
                                "fontSize": 14,
                                "fontWeight": "w600",
                                "color": "#3F4748",
                                "fontFamily": "SourceSans3"
                              }
                            }
                          }
                        }
                      },
                    ]
                  }
                }
              ]
            },
            "body": {
              "type": "customScrollView",
              "slivers": [
                {
                  "type": "sliverAppBar",
                  "expandedHeight": 220,
                  "backgroundColor": "#000000",
                  "collapsedHeight": 60,
                  "toolbarHeight": 56,
                  "pinned": true,
                  "floating": false,
                  "snap": false,
                  "clipBehavior": "antiAlias",
                  "stretch": true,
                  "iconTheme": {
                    "color": "#FFFFFF",
                    "size": 16,
                  },
                  "flexibleSpace": {
                    "type": "flexibleSpaceBar",
                    "collapseMode": "pin",
                    "background": {
                      "type": "container",
                      "height": 220,
                      "clipBehavior": "hardEdge",
                      "decoration": {
                        "gradient": {
                          "type": "linear",
                          "begin": "topCenter",
                          "end": "bottomCenter",
                          "colors": ["#023C40", "#1C272B", "#1e1e21"],
                          "stops": [0.0, 0.6009, 1.2017]
                        }
                      },
                      "child": {
                        "type": "padding",
                        "padding": {"top": 100, "left": 20, "right": 20},
                        "child": {
                          "type": "row",
                          "mainAxisAlignment": "spaceBetween",
                          "crossAxisAlignment": "start",
                          "children": [
                            {
                              "type": "column",
                              "crossAxisAlignment": "start",
                              "children": [
                                {
                                  "type": "text",
                                  "data": "Insurance Advice",
                                  "style": {
                                    "fontSize": 22,
                                    "fontWeight": "w600",
                                    "color": "#FFFFFF",
                                    "fontFamily": "SourceSans3"
                                  }
                                },
                                {
                                  "type": "text",
                                  "data": "Tailored to You - From",
                                  "style": {
                                    "fontSize": 22,
                                    "fontWeight": "w600",
                                    "color": "#FFFFFF",
                                    "fontFamily": "SourceSans3"
                                  }
                                },
                                {
                                  "type": "text",
                                  "data": "Certified Experts",
                                  "style": {
                                    "fontSize": 22,
                                    "fontWeight": "w600",
                                    "color": "#4AE3B5",
                                    "fontFamily": "SourceSans3"
                                  }
                                }
                              ]
                            },
                            {
                              "type": "appImage",
                              "image":
                                  "https://d18gbwu7fwwwtf.cloudfront.net/shield.png",
                              "height": 94,
                              "width": 84,
                            }
                          ]
                        }
                      }
                    }
                  }
                },
                {
                  "type": "sliverToBoxAdapter",
                  "child": {
                    "type": "container",
                    "padding": {
                      "top": 20,
                      "left": 20,
                      "right": 20,
                      "bottom": 20,
                    },
                    "color": "#232326",
                    "child": {
                      "type": "column",
                      "crossAxisAlignment": "start",
                      "children": [
                        {
                          "type": "text",
                          "data":
                              "CHOOSING INSURANCE IS OVERWHELMING - WE MAKE IT EASY",
                          "style": {
                            "fontSize": 14,
                            "fontWeight": "w500",
                            "color": "#FFFFFF",
                            "fontFamily": "SourceSans3"
                          }
                        },
                        {"type": "sizedBox", "height": 12},
                        {
                          "type": "container",
                          "padding": {
                            "top": 24,
                            "left": 18,
                            "right": 18,
                            "bottom": 24,
                          },
                          "decoration": {
                            "color": "#2D3135",
                            "borderRadius": {
                              "topLeft": 10,
                              "topRight": 10,
                              "bottomLeft": 10,
                              "bottomRight": 10,
                            }
                          },
                          "child": {
                            "type": "column",
                            "crossAxisAlignment": "start",
                            "children": [
                              {
                                "type": "row",
                                "crossAxisAlignment": "center",
                                "children": [
                                  {
                                    "type": "container",
                                    "height": 40,
                                    "width": 40,
                                    "padding": {
                                      "top": 12,
                                      "bottom": 12,
                                      "left": 12,
                                      "right": 12,
                                    },
                                    "decoration": {
                                      "color": "#01656B66",
                                      "borderRadius": {
                                        "topLeft": 100,
                                        "topRight": 100,
                                        "bottomLeft": 100,
                                        "bottomRight": 100,
                                      }
                                    },
                                    "child": {
                                      "type": "appImage",
                                      "image": "assets/svg/purse.svg",
                                      "color": "#62E3C4",
                                      "height": 16,
                                      "width": 16
                                    }
                                  },
                                  {"type": "sizedBox", "width": 16},
                                  {
                                    "type": "expanded",
                                    "child": {
                                      "type": "column",
                                      "crossAxisAlignment": "start",
                                      "children": [
                                        {
                                          "type": "text",
                                          "data": "Avoid Overpaying",
                                          "style": {
                                            "fontSize": 14,
                                            "fontWeight": "w600",
                                            "color": "#FFFFFF",
                                            "fontFamily": "SourceSans3"
                                          }
                                        },
                                        {"type": "sizedBox", "height": 4},
                                        {
                                          "type": "text",
                                          "data":
                                              "We help you find the best coverage at the right price.",
                                          "maxLines": 2,
                                          "style": {
                                            "fontSize": 12,
                                            "fontWeight": "w400",
                                            "color": "#CACBCC",
                                            "fontFamily": "SourceSans3"
                                          }
                                        },
                                      ]
                                    },
                                  }
                                ]
                              },
                              {"type": "sizedBox", "height": 28},
                              {
                                "type": "row",
                                "crossAxisAlignment": "center",
                                "children": [
                                  {
                                    "type": "container",
                                    "height": 40,
                                    "padding": {
                                      "top": 12,
                                      "bottom": 12,
                                      "left": 12,
                                      "right": 12,
                                    },
                                    "width": 40,
                                    "decoration": {
                                      "color": "#01656B66",
                                      "borderRadius": {
                                        "topLeft": 100,
                                        "topRight": 100,
                                        "bottomLeft": 100,
                                        "bottomRight": 100,
                                      }
                                    },
                                    "child": {
                                      "type": "appImage",
                                      "image": "assets/svg/expertise.svg",
                                      "color": "#62E3C4",
                                      "height": 16,
                                      "width": 16
                                    }
                                  },
                                  {"type": "sizedBox", "width": 16},
                                  {
                                    "type": "expanded",
                                    "child": {
                                      "type": "column",
                                      "crossAxisAlignment": "start",
                                      "children": [
                                        {
                                          "type": "text",
                                          "data":
                                              "No More Fine Print Confusion",
                                          "style": {
                                            "fontSize": 14,
                                            "fontWeight": "w600",
                                            "color": "#FFFFFF",
                                            "fontFamily": "SourceSans3"
                                          }
                                        },
                                        {"type": "sizedBox", "height": 4},
                                        {
                                          "type": "text",
                                          "data":
                                              "We explain policies in simple terms.",
                                          "maxLines": 2,
                                          "style": {
                                            "fontSize": 12,
                                            "fontWeight": "w400",
                                            "color": "#CACBCC",
                                            "fontFamily": "SourceSans3"
                                          }
                                        },
                                      ]
                                    },
                                  }
                                ]
                              },
                              {"type": "sizedBox", "height": 28},
                              {
                                "type": "row",
                                "crossAxisAlignment": "center",
                                "children": [
                                  {
                                    "type": "container",
                                    "height": 40,
                                    "width": 40,
                                    "padding": {
                                      "top": 12,
                                      "bottom": 12,
                                      "left": 12,
                                      "right": 12,
                                    },
                                    "decoration": {
                                      "color": "#01656B66",
                                      "borderRadius": {
                                        "topLeft": 100,
                                        "topRight": 100,
                                        "bottomLeft": 100,
                                        "bottomRight": 100,
                                      }
                                    },
                                    "child": {
                                      "type": "appImage",
                                      "image": "assets/svg/safe.svg",
                                      "color": "#62E3C4",
                                      "height": 16,
                                      "width": 16
                                    }
                                  },
                                  {"type": "sizedBox", "width": 16},
                                  {
                                    "type": "expanded",
                                    "child": {
                                      "type": "column",
                                      "crossAxisAlignment": "start",
                                      "children": [
                                        {
                                          "type": "text",
                                          "data": "Unbiased Advice",
                                          "style": {
                                            "fontSize": 14,
                                            "fontWeight": "w600",
                                            "color": "#FFFFFF",
                                            "fontFamily": "SourceSans3"
                                          }
                                        },
                                        {"type": "sizedBox", "height": 4},
                                        {
                                          "type": "text",
                                          "data":
                                              "We compare multiple providers, so you get the best.",
                                          "maxLines": 2,
                                          "style": {
                                            "fontSize": 12,
                                            "fontWeight": "w400",
                                            "color": "#CACBCC",
                                            "fontFamily": "SourceSans3"
                                          }
                                        },
                                      ]
                                    },
                                  }
                                ]
                              },
                              {"type": "sizedBox", "height": 28},
                              {
                                "type": "row",
                                "crossAxisAlignment": "center",
                                "children": [
                                  {
                                    "type": "container",
                                    "height": 40,
                                    "width": 40,
                                    "padding": {
                                      "top": 12,
                                      "bottom": 12,
                                      "left": 12,
                                      "right": 12,
                                    },
                                    "decoration": {
                                      "color": "#01656B66",
                                      "borderRadius": {
                                        "topLeft": 100,
                                        "topRight": 100,
                                        "bottomLeft": 100,
                                        "bottomRight": 100,
                                      }
                                    },
                                    "child": {
                                      "type": "appImage",
                                      "image": "assets/svg/chat.svg",
                                      "color": "#62E3C4",
                                      "height": 16,
                                      "width": 16
                                    }
                                  },
                                  {"type": "sizedBox", "width": 16},
                                  {
                                    "type": "expanded",
                                    "child": {
                                      "type": "column",
                                      "crossAxisAlignment": "start",
                                      "children": [
                                        {
                                          "type": "text",
                                          "data": "Stress-Free Claims Support",
                                          "style": {
                                            "fontSize": 14,
                                            "fontWeight": "w600",
                                            "color": "#FFFFFF",
                                            "fontFamily": "SourceSans3"
                                          }
                                        },
                                        {"type": "sizedBox", "height": 4},
                                        {
                                          "type": "text",
                                          "data":
                                              "We guide you from purchase to claims.",
                                          "maxLines": 2,
                                          "style": {
                                            "fontSize": 12,
                                            "fontWeight": "w400",
                                            "color": "#CACBCC",
                                            "fontFamily": "SourceSans3"
                                          }
                                        },
                                      ]
                                    },
                                  }
                                ]
                              },
                            ]
                          }
                        }
                      ]
                    }
                  }
                },
                {
                  "type": "sliverToBoxAdapter",
                  "child": {
                    "type": "container",
                    "padding": {
                      "top": 24,
                      "left": 18,
                      "right": 18,
                      "bottom": 24,
                    },
                    "child": {
                      "type": "column",
                      "crossAxisAlignment": "start",
                      "children": [
                        {
                          "type": "text",
                          "data": "YOUR PERSONAL INSURANCE EXPERTS",
                          "style": {
                            "fontSize": 14,
                            "fontWeight": "w500",
                            "color": "#FFFFFF",
                            "fontFamily": "SourceSans3"
                          }
                        },
                        {"type": "sizedBox", "height": 24},
                        {
                          "type": "container",
                          "height": 280,
                          "child": {
                            "type": "dynamicView",
                            "request": {
                              "url":
                                  "https://advisors.fello-dev.net/advisors/sections",
                              "cBaseUrl": '',
                              "method": "get",
                            },
                            "targetPath": "data.values.Top",
                            "template": {
                              "type": "listView",
                              "scrollDirection": "horizontal",
                              "children": [],
                              "ItemTemplate": {
                                "type": "container",
                                "margin": {"right": 12},
                                "child": {
                                  "type": "gestureDetector",
                                  "onTap": {
                                    "type": "action",
                                    "actionType": "navigate",
                                    "navigationStyle": "link",
                                    "routeName": "/experts?id={{advisorId}}"
                                  },
                                  "child": {
                                    "type": "sizedBox",
                                    "width": 225,
                                    "child": {
                                      "type": "stack",
                                      "alignment": "bottomCenter",
                                      "children": [
                                        {
                                          "type": "positioned",
                                          "left": -2,
                                          "bottom": -45,
                                          "child": {
                                            "type": "borderedText",
                                            "strokeWidth": 1.5,
                                            "strokeColor": "#00000000",
                                            "gradient": {
                                              "type": "linear",
                                              "begin": "topCenter",
                                              "end": "bottomCenter",
                                              "colors": ["#01656B", "#14A0854D"]
                                            },
                                            "text": "{{index}}",
                                            "fontSize": 125,
                                          }
                                        },
                                        {
                                          "type": "sizedBox",
                                          "width": 168,
                                          "child": {
                                            "type": "container",
                                            "decoration": {
                                              "color": "#2D3135",
                                              "borderRadius": {
                                                "topLeft": 6,
                                                "topRight": 6,
                                                "bottomLeft": 6,
                                                "bottomRight": 6
                                              },
                                              "boxShadow": [
                                                {
                                                  "color": "#00000040",
                                                  "blurRadius": 2,
                                                  "offset": {"dx": 0, "dy": 1}
                                                }
                                              ]
                                            },
                                            "padding": {
                                              "top": 10,
                                              "left": 10,
                                              "right": 10,
                                              "bottom": 10
                                            },
                                            "child": {
                                              "type": "column",
                                              "children": [
                                                {
                                                  "type": "stack",
                                                  "children": [
                                                    {
                                                      "type": "clipRRect",
                                                      "borderRadius": {
                                                        "topLeft": 6,
                                                        "topRight": 6,
                                                        "bottomLeft": 6,
                                                        "bottomRight": 6
                                                      },
                                                      "child": {
                                                        "type": "image",
                                                        "src": "{{image}}",
                                                        "height": 152,
                                                        "width": 148,
                                                        "fit": "cover"
                                                      }
                                                    },
                                                    {
                                                      "type": "positioned",
                                                      "bottom": 8,
                                                      "child": {
                                                        "type": "sizedBox",
                                                        "width": 140,
                                                        "child": {
                                                          "type": "row",
                                                          "mainAxisAlignment":
                                                              "spaceBetween",
                                                          "children": [
                                                            {
                                                              "type":
                                                                  "container",
                                                              "padding": {
                                                                "top": 4,
                                                                "left": 4,
                                                                "right": 4,
                                                                "bottom": 4
                                                              },
                                                              "margin": {
                                                                "left": 10
                                                              },
                                                              "decoration": {
                                                                "color":
                                                                    "#3d3f44",
                                                                "borderRadius":
                                                                    {
                                                                  "topLeft": 5,
                                                                  "topRight": 5,
                                                                  "bottomLeft":
                                                                      5,
                                                                  "bottomRight":
                                                                      5
                                                                }
                                                              },
                                                              "child": {
                                                                "type": "row",
                                                                "mainAxisAlignment":
                                                                    "spaceBetween",
                                                                "crossAxisAlignment":
                                                                    "center",
                                                                "children": [
                                                                  {
                                                                    "type":
                                                                        "appImage",
                                                                    "image":
                                                                        "assets/svg/experience.svg",
                                                                    "height": 10
                                                                  },
                                                                  {
                                                                    "type":
                                                                        "sizedBox",
                                                                    "width": 2
                                                                  },
                                                                  {
                                                                    "type":
                                                                        "text",
                                                                    "data":
                                                                        " {{experience}} Years",
                                                                    "style": {
                                                                      "fontSize":
                                                                          10,
                                                                      "fontWeight":
                                                                          "w400",
                                                                      "color":
                                                                          "#FFFFFF",
                                                                      "fontFamily":
                                                                          "SourceSans3"
                                                                    }
                                                                  }
                                                                ]
                                                              }
                                                            },
                                                            {
                                                              "type":
                                                                  "container",
                                                              "padding": {
                                                                "top": 4,
                                                                "left": 4,
                                                                "right": 4,
                                                                "bottom": 4
                                                              },
                                                              "decoration": {
                                                                "color":
                                                                    "#3d3f44",
                                                                "borderRadius":
                                                                    {
                                                                  "topLeft": 5,
                                                                  "topRight": 5,
                                                                  "bottomLeft":
                                                                      5,
                                                                  "bottomRight":
                                                                      5
                                                                }
                                                              },
                                                              "margin": {
                                                                "right": 10
                                                              },
                                                              "child": {
                                                                "type": "row",
                                                                "mainAxisAlignment":
                                                                    "start",
                                                                "crossAxisAlignment":
                                                                    "center",
                                                                "children": [
                                                                  {
                                                                    "type":
                                                                        "icon",
                                                                    "icon":
                                                                        "star",
                                                                    "color":
                                                                        "#F5A623",
                                                                    "size": 10
                                                                  },
                                                                  {
                                                                    "type":
                                                                        "sizedBox",
                                                                    "width": 2
                                                                  },
                                                                  {
                                                                    "type":
                                                                        "text",
                                                                    "data":
                                                                        "{{rating}}",
                                                                    "style": {
                                                                      "fontSize":
                                                                          10,
                                                                      "fontWeight":
                                                                          "w400",
                                                                      "color":
                                                                          "#FFFFFF",
                                                                      "fontFamily":
                                                                          "SourceSans3"
                                                                    }
                                                                  }
                                                                ]
                                                              }
                                                            }
                                                          ]
                                                        }
                                                      }
                                                    }
                                                  ]
                                                },
                                                {
                                                  "type": "sizedBox",
                                                  "height": 18
                                                },
                                                {
                                                  "type": "column",
                                                  "crossAxisAlignment": "start",
                                                  "children": [
                                                    {
                                                      "type": "text",
                                                      "data": "{{name}}",
                                                      "style": {
                                                        "fontSize": 16,
                                                        "fontWeight": "w600",
                                                        "color": "#FFFFFF",
                                                        "fontFamily":
                                                            "SourceSans3"
                                                      },
                                                      "maxLines": 1,
                                                      "overflow": "ellipsis"
                                                    },
                                                    {
                                                      "type": "sizedBox",
                                                      "height": 20
                                                    },
                                                    {
                                                      "type": "row",
                                                      "children": [
                                                        {
                                                          "type": "appImage",
                                                          "image":
                                                              "assets/svg/expertise.svg",
                                                          "height": 12
                                                        },
                                                        {
                                                          "type": "sizedBox",
                                                          "width": 4
                                                        },
                                                        {
                                                          "type": "expanded",
                                                          "child": {
                                                            "type": "text",
                                                            "data":
                                                                "{{expertise}}",
                                                            "style": {
                                                              "fontSize": 12,
                                                              "fontWeight":
                                                                  "w600",
                                                              "color":
                                                                  "#FFFFFF",
                                                              "fontFamily":
                                                                  "SourceSans3"
                                                            },
                                                            "maxLines": 1,
                                                            "overflow":
                                                                "ellipsis"
                                                          }
                                                        }
                                                      ]
                                                    },
                                                    {
                                                      "type": "sizedBox",
                                                      "height": 5
                                                    },
                                                    {
                                                      "type": "row",
                                                      "children": [
                                                        {
                                                          "type": "appImage",
                                                          "image":
                                                              "assets/svg/qualifications.svg",
                                                          "height": 12
                                                        },
                                                        {
                                                          "type": "sizedBox",
                                                          "width": 4
                                                        },
                                                        {
                                                          "type": "expanded",
                                                          "child": {
                                                            "type": "text",
                                                            "data":
                                                                "{{qualifications}}",
                                                            "style": {
                                                              "fontSize": 12,
                                                              "fontWeight":
                                                                  "w600",
                                                              "color":
                                                                  "#FFFFFF",
                                                              "fontFamily":
                                                                  "SourceSans3"
                                                            },
                                                            "maxLines": 1,
                                                            "overflow":
                                                                "ellipsis"
                                                          }
                                                        }
                                                      ]
                                                    }
                                                  ]
                                                }
                                              ]
                                            }
                                          }
                                        }
                                      ]
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      ]
                    }
                  }
                },
                {
                  "type": "sliverToBoxAdapter",
                  "child": {
                    "type": "container",
                    "padding": {
                      "top": 24,
                      "left": 18,
                      "right": 18,
                      "bottom": 24,
                    },
                    "child": {
                      "type": "column",
                      "crossAxisAlignment": "start",
                      "children": [
                        {
                          "type": "text",
                          "data": "HOW IT WORKS – IN 3 SIMPLE STEPS",
                          "style": {
                            "fontSize": 14,
                            "fontWeight": "w500",
                            "color": "#FFFFFF",
                            "fontFamily": "SourceSans3"
                          }
                        },
                        {"type": "sizedBox", "height": 24},
                        {
                          "type": "timeline",
                          "nodeSize": 20,
                          "nodeInnerSize": 14,
                          "nodeInnerMostSize": 10,
                          "lineHeight": 28,
                          "lineWidth": 0.6,
                          "spacing": 20,
                          "nodes": [
                            {
                              "title": "Tell Us Your Needs",
                              "description":
                                  "Answer a few quick questions about your insurance goals.",
                              "completed": true
                            },
                            {
                              "title": "Get Personalized Advice",
                              "description":
                                  "A certified expert will analyze and recommend the best plans.",
                              "completed": true
                            },
                            {
                              "title": "Compare & Choose",
                              "description":
                                  "Get unbiased comparisons and pick the right insurance from wherever you want.",
                              "completed": true
                            }
                          ],
                          "primaryColor": "#1E2532",
                          "secondaryColor": "#2A3343",
                          "tertiaryColor": "#62E3C4",
                          "dashGap": 2,
                        },
                        {"type": "sizedBox", "height": 40},
                        {
                          "type": "row",
                          "mainAxisAlignment": "spaceAround",
                          "children": [
                            {
                              "type": "text",
                              "data": "100% Unbiased",
                              "style": {
                                "fontSize": 10,
                                "fontWeight": "w500",
                                "color": "#A6A6AC",
                                "fontFamily": "SourceSans3"
                              }
                            },
                            {
                              "type": "container",
                              "width": 4,
                              "height": 4,
                              "decoration": {
                                "color": "#A6A6AC",
                                "borderRadius": 100,
                              }
                            },
                            {
                              "type": "text",
                              "data": "7+ Years Experience",
                              "style": {
                                "fontSize": 10,
                                "fontWeight": "w500",
                                "color": "#A6A6AC",
                                "fontFamily": "SourceSans3"
                              }
                            },
                            {
                              "type": "container",
                              "width": 4,
                              "height": 4,
                              "decoration": {
                                "color": "#A6A6AC",
                                "borderRadius": 100,
                              }
                            },
                            {
                              "type": "text",
                              "data": "1000+ Happy Clients",
                              "style": {
                                "fontSize": 10,
                                "fontWeight": "w500",
                                "color": "#A6A6AC",
                                "fontFamily": "SourceSans3"
                              }
                            }
                          ]
                        },
                      ],
                    },
                  }
                },
                {
                  "type": "sliverToBoxAdapter",
                  "child": {
                    "type": "container",
                    "padding": {
                      "top": 24,
                      "left": 18,
                      "right": 18,
                      "bottom": 24
                    },
                    "color": "#232326",
                    "child": {
                      "type": "column",
                      "crossAxisAlignment": "start",
                      "children": [
                        {
                          "type": "text",
                          "data": "THE PROOF WRITES ITSELF",
                          "style": {
                            "fontSize": 14,
                            "fontWeight": "w500",
                            "color": "#FFFFFF",
                            "fontFamily": "SourceSans3"
                          }
                        },
                        {"type": "sizedBox", "height": 12},
                        {
                          "type": "container",
                          "height": 180,
                          "child": {
                            "type": "dynamicView",
                            "request": {
                              "url":
                                  "https://advisors.fello-dev.net/users/testimonials",
                              "cBaseUrl": "",
                              "method": "get"
                            },
                            "targetPath": "data",
                            "template": {
                              "type": "listView",
                              "scrollDirection": "horizontal",
                              "children": [],
                              "ItemTemplate": {
                                "type": "container",
                                "margin": {"right": 16},
                                "child": {
                                  "type": "sizedBox",
                                  "width": 300,
                                  "child": {
                                    "type": "container",
                                    "decoration": {
                                      "color": "#2D3135",
                                      "borderRadius": {
                                        "topLeft": 10,
                                        "topRight": 10,
                                        "bottomLeft": 10,
                                        "bottomRight": 10
                                      },
                                      "boxShadow": [
                                        {
                                          "color": "#00000040",
                                          "blurRadius": 2,
                                          "offset": {"dx": 0, "dy": 1}
                                        }
                                      ]
                                    },
                                    "padding": {
                                      "top": 18,
                                      "left": 18,
                                      "right": 18,
                                      "bottom": 18
                                    },
                                    "child": {
                                      "type": "column",
                                      "crossAxisAlignment": "start",
                                      "children": [
                                        {
                                          "type": "row",
                                          "children": [
                                            {
                                              "type": "container",
                                              "width": 40,
                                              "height": 40,
                                              "decoration": {
                                                "color": "#000000",
                                                "borderRadius": 100,
                                              },
                                              "child": {
                                                "type": "appImage",
                                                "image":
                                                    "assets/vectors/userAvatars/{{avatarId}}.svg",
                                                "width": 40,
                                                "height": 40,
                                                "fit": "cover"
                                              }
                                            },
                                            {"type": "sizedBox", "width": 14},
                                            {
                                              "type": "column",
                                              "crossAxisAlignment": "start",
                                              "children": [
                                                {
                                                  "type": "text",
                                                  "data": "{{userName}}",
                                                  "style": {
                                                    "fontSize": 14,
                                                    "fontWeight": "w600",
                                                    "color": "#FFFFFF",
                                                    "fontFamily": "SourceSans3"
                                                  },
                                                  "maxLines": 1,
                                                  "overflow": "ellipsis"
                                                },
                                                {
                                                  "type": "row",
                                                  "crossAxisAlignment":
                                                      "center",
                                                  "children": [
                                                    {
                                                      "type": "text",
                                                      "data": "{{rating}} ",
                                                      "style": {
                                                        "fontSize": 12,
                                                        "fontWeight": "w500",
                                                        "color": "#FFFFFF",
                                                        "fontFamily":
                                                            "SourceSans3"
                                                      }
                                                    },
                                                    {
                                                      "type": "icon",
                                                      "icon": "star_rounded",
                                                      "color": "#F5A623",
                                                      "size": 12
                                                    },
                                                    {
                                                      "type": "container",
                                                      "padding": {
                                                        "left": 4,
                                                        "right": 4
                                                      },
                                                      "child": {
                                                        "type": "icon",
                                                        "icon": "circle",
                                                        "color": "#A6A6AC",
                                                        "size": 4
                                                      }
                                                    },
                                                    {
                                                      "type": "text",
                                                      "data": "{{timeAgo}}",
                                                      "style": {
                                                        "fontSize": 12,
                                                        "fontWeight": "w500",
                                                        "color": "#A6A6AC",
                                                        "fontFamily":
                                                            "SourceSans3"
                                                      }
                                                    }
                                                  ]
                                                }
                                              ]
                                            }
                                          ]
                                        },
                                        {"type": "sizedBox", "height": 18},
                                        {
                                          "type": "expanded",
                                          "child": {
                                            "type": "text",
                                            "data": "{{review}}",
                                            "style": {
                                              "fontSize": 14,
                                              "fontWeight": "w400",
                                              "color": "#FFFFFF",
                                              "fontFamily": "SourceSans3"
                                            },
                                            "maxLines": 5,
                                            "overflow": "ellipsis"
                                          }
                                        }
                                      ]
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      ]
                    }
                  }
                }
              ]
            }
          },
          context,
        ) ??
        SizedBox.shrink();
  }
}
