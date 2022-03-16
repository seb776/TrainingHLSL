Shader "Unlit/MagicCircle"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color("MainColor", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "RenderQueue"="Transparent" }
        LOD 100
        Blend SrcAlpha One
        ZTest Always
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
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;

            float _sqr(float2 uv, float2 s)
            {
                float2 l = abs(uv) - s;
                return max(l.x, l.y);
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }
#define PI 3.14159265
            float2x2 r2d(float a) { float c = cos(a), s = sin(a); return float2x2(c, -s, s, c); }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
            float2 uv = i.uv - 0.5;
            col = 8.*fixed4(235, 134, 52,255)/255;

            float th = 0.001;
            float sharp = 400.;

            // Inner Squares
            float sqrShape = 1000.;
            for (int j = 0; j < 4; ++j)
            {
                float2 luv = uv;
                float angle = (PI / 4.) * float(j);
                luv = mul(r2d(angle+smoothstep(-1.,1.,sin(_Time.y+j))), luv);
                float shape = abs(_sqr(luv, float2(1., 1.) * .2)) - th;
                sqrShape = min(sqrShape, shape);
            }
            col.w = 1.-saturate(sqrShape * sharp);

            // outerCircle
            float outerCircle = abs(length(uv) - .4) - .01;
            col.xyz = lerp(col.xyz, 20. * float3(255, 70, 52) / 255., 1.-saturate(outerCircle * sharp));
            col.w = max(col.w, 1.-saturate(outerCircle*sharp));
            float2 uvOC2 = uv;
            float repOC2 = PI * 2. / 24.;
            float aOC2 = atan2(uvOC2.y, uvOC2.x);
            float idsector = floor((aOC2 + repOC2 * .5 + PI) / repOC2);
            float sectorOC2 = fmod(aOC2 + repOC2 * .5+PI, repOC2) - repOC2 * .5;
            uvOC2 = float2(sin(sectorOC2), cos(sectorOC2)) * length(uvOC2) - float2(0., .3);
            uvOC2 = mul(uvOC2, r2d(sin(idsector + _Time.y)));
            float outerCircle2 = abs(_sqr(uvOC2, float2(1., 1.) * .05))-th;
            col.xyz = lerp(col.xyz, 2. * float3(255, 59, 163) / 255., 1. - saturate(outerCircle2 * sharp*.25));
            col.w = max(col.w, 1. - saturate(outerCircle2 * sharp*.25));

            col.w = saturate(col.w + pow(1. - saturate((length(uv) - .125)*10.),5.5)*.25);

            col.xyz *= _Color;
            // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
