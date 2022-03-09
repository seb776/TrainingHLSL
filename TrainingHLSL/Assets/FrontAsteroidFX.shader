// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/FrontAsteroidFX"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ColorA("ColorA", Color) = (1,1,1,1)
        _ColorB("ColorB", Color) = (1,1,1,1)
        _Attenuation("Attenuation", Range(0,10)) = 0.5
        _Multiplier("Multiplier", Range(0,1000)) = 0.5
        _Speed("Speed", Range(0,10)) = 0.5
        _ScaleA("ScaleA", Range(0,1)) = 0.5
        _PowA("PowA", Range(0,10)) = 0.5
        _ScaleB("ScaleB", Range(0,1)) = 0.5
        _PowB("PowB", Range(0,10)) = 0.5
        _ZOff("ZOff", Range(-1,1)) = 0.5
        _ZMult("ZMult", Range(0,10)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "RenderQueue"="Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha
        LOD 100
        Cull Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float4 objPos : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            fixed4 _ColorA;
            fixed4 _ColorB;
            float _Attenuation;
            float _ScaleA;
            float _PowA;
            float _ScaleB;
            float _PowB;
            float _Multiplier;
            float _Speed;
            float _ZOff;
            float _ZMult;

            float _MonFloatTest;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.objPos = v.vertex;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float3 p = i.objPos;
                float2 f = i.uv;//float2(atan2(p.y, p.z), length(p));
                float na = tex2D(_MainTex, _ScaleA*f - _Time.xy * .05*_Speed).x;
                float nb = tex2D(_MainTex, _ScaleB*f * float2(1., 5.) - _Time.xy * .1* _Speed).x;
                na = pow(na, _PowA);
                nb = pow(nb, _PowB);
                float atten = (1. - saturate(length(p) / _Attenuation));
                atten *= 1.-saturate((p.y - _ZOff)*_ZMult);
                fixed4 res = saturate(fixed4((na*_ColorA +nb*_ColorB).xyz, (na+nb)*.5)) * atten;
                res.xyz *= _Multiplier;
                //res = float4(float3(1., 1., 1.) * atten, 1.0);
                res.w = atten*.5;
                res *= pow(_MonFloatTest,.5) *10.;
                return (res);
            }
            ENDCG
        }
    }
}
