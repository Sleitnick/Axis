"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[671],{59881:function(e,t,r){r.r(t),r.d(t,{frontMatter:function(){return s},contentTitle:function(){return d},metadata:function(){return l},toc:function(){return p},default:function(){return u}});var i=r(87462),o=r(63366),n=(r(67294),r(3905)),a=["components"],s={sidebar_position:1},d="Getting Started",l={unversionedId:"intro",id:"intro",isDocsHomePage:!1,title:"Getting Started",description:"Axis is a provider framework for the Roblox ecosystem. Providers are simple structures that provide high-level encapsulation of logic, along with lifecycle methods to help accommodate communication between each other.",source:"@site/docs/intro.md",sourceDirName:".",slug:"/intro",permalink:"/Axis/docs/intro",editUrl:"https://github.com/Sleitnick/Axis/edit/master/docs/intro.md",tags:[],version:"current",sidebarPosition:1,frontMatter:{sidebar_position:1},sidebar:"defaultSidebar",next:{title:"Providers",permalink:"/Axis/docs/providers"}},p=[],c={toc:p};function u(e){var t=e.components,r=(0,o.Z)(e,a);return(0,n.kt)("wrapper",(0,i.Z)({},c,r,{components:t,mdxType:"MDXLayout"}),(0,n.kt)("h1",{id:"getting-started"},"Getting Started"),(0,n.kt)("p",null,"Axis is a provider framework for the Roblox ecosystem. Providers are simple structures that provide high-level encapsulation of logic, along with lifecycle methods to help accommodate communication between each other."),(0,n.kt)("p",null,"A provider in its simplest form may look like this:"),(0,n.kt)("pre",null,(0,n.kt)("code",{parentName:"pre",className:"language-lua"},"local MyProvider = {}\n\nfunction MyProvider:AxisPrepare()\nend\n\nfunction MyProvider:AxisStarted()\nend\n\nreturn MyProvider\n")),(0,n.kt)("p",null,"To add a provider to Axis, call the ",(0,n.kt)("inlineCode",{parentName:"p"},"AddProvider")," method:"),(0,n.kt)("pre",null,(0,n.kt)("code",{parentName:"pre",className:"language-lua"},"Axis:AddProvider(MyProvider)\n")),(0,n.kt)("p",null,"Because providers are just Lua tables, developers can add any desired methods and functionality to them as needed. The two ",(0,n.kt)("inlineCode",{parentName:"p"},"AxisPrepare")," and ",(0,n.kt)("inlineCode",{parentName:"p"},"AxisStarted")," methods are lifecycle methods that Axis will call during startup. ",(0,n.kt)("inlineCode",{parentName:"p"},"AxisPrepare")," is called first, and should be used to prepare the provider for use. ",(0,n.kt)("inlineCode",{parentName:"p"},"AxisStarted")," is called after ",(0,n.kt)("em",{parentName:"p"},"all")," other providers have completed their ",(0,n.kt)("inlineCode",{parentName:"p"},"AxisPrepare")," methods. At this point, it is safe to assume that other providers can be used from within a provider."),(0,n.kt)("p",null,"Typically, there will be one script per server/client that will gather all providers and extensions, and then add them to Axis. Once all providers and extensions are added, Axis can be started."))}u.isMDXComponent=!0}}]);