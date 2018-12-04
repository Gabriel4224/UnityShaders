Shader "Custom/PulseShader" {
	Properties {
		_MainTex("Base (RGB)", 2D) = "white" {}
	    _GlowColour("Glow RGB", Color) = (1.0, 1.0, 1.0, 1.0)

		_Frequency("Glow Frequency", Float) = 1.0
		_MinPulseValue("Minimum Glow Multiplier", Range(0, 1)) = 0

	}
	SubShader {
		Tags{ "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
       #pragma surface surf Lambert

	   sampler2D	_MainTex;
	    fixed4		_GlowColour;

	    half		_Frequency;
	    half		_MinPulseValue;

	struct Input {
		float2 uv_MainTex;
	};

	void surf(Input IN, inout SurfaceOutput o)
	{
		half4 Colour = tex2D(_MainTex, IN.uv_MainTex);
		half SinPos = 0.5 * sin(_Frequency * _Time.x) + 0.5;
		half PulseMultiplier = SinPos * (1 - _MinPulseValue) + _MinPulseValue;

		o.Albedo = Colour.rgb * _GlowColour.rgb * PulseMultiplier;
		o.Alpha = Colour.a;

	}
		ENDCG
	}
	FallBack "Diffuse"
}
