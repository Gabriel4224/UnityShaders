

Shader "Custom/OutlineShader" {
	Properties{
		// Colour of the outline
		_outlineColor("Outline Color", Color) = (0,0,0,1)
		// Width of the outline
		_outline("Outline width", Range(0.0, 0.10)) = .005
	}

		CGINCLUDE
#include "UnityCG.cginc"

		struct appdata {
		float4 vertex : POSITION;
		float3 normal : NORMAL;
	};

	struct v2f {
		float4 Pos : POSITION;
		float4 Colour : COLOR;
	};

	uniform float _outline;
	uniform float4 _outlineColor;

	v2f vert(appdata v) {
		// just make a copy of incoming vertex data but scaled according to normal direction
		v2f o;
		o.Pos = UnityObjectToClipPos(v.vertex);

		float3 Norm = mul((float3x3)UNITY_MATRIX_IT_MV, v.normal);
		float2 Offset = TransformViewToProjection(Norm.xy);
		o.Pos.xy += Offset * o.Pos.z * _outline;
		o.Colour = _outlineColor;
		return o;
	}
	ENDCG

		SubShader{
		Tags{ "Queue" = "Transparent" }

		Pass{
		Name "BASE"
		Cull back
  		Blend Zero One

		SetTexture[_outlineColor]
		{
			ConstantColor(0,0,0,0)
			Combine constant
		}
	}

		// note that a vertex shader is specified here but its using the one above
		Pass{
		Name "OUTLINE"
		Tags{ "LightMode" = "Always" }
		Cull Front
		// ZWrite On
		// Strong Additive 
		Blend One One 
								   

		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag

		half4 frag(v2f i) :COLOR{
		return i.Colour;
	}
		ENDCG
	}
	}	
		Fallback "Diffuse"
}