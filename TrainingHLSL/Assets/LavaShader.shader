Shader "Unlit/LavaShader"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _LavaTex("Lava Texture", 2D) = "white" {}
        [HDR]_Color("Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

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
            sampler2D _LavaTex;
            float3 _Color;

            v2f vert (appdata v)
            {
                v2f o;
                float3 myvertex = v.vertex + float3(0, sin(_Time.y + length(v.vertex.xz - 50.5)), 0);

                o.vertex = UnityObjectToClipPos(myvertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = float4(0,0,0,1);

            float lavaMask = tex2D(_MainTex, i.uv).x;
            float2 uv = i.uv - float2(.5,.4);
            float r = length(uv)-_Time.x*.05;
            float a = atan2(uv.y, uv.x)/3.14159265;
            float2 puv = float2(a, r);
            //puv += float2(0, _Time.y * .1);
            col.xyz = _Color*tex2D(_LavaTex, puv * 5.).xyz*lavaMask;

                //col.xyz *= _Color;
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
