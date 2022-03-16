Shader "Unlit/LIGHTING01_Shader"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
    }
        SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100



        Pass
        {
            CGPROGRAM

                        #pragma vertex vert
                        #pragma fragment frag
                        #pragma multi_compile_fog



                        #include "UnityCG.cginc"



                        struct appdata
                        {
                            float4 vertex : POSITION;
                            float2 uv : TEXCOORD0;
                            float3 normal : NORMAL;
                        };



                        struct v2f
                        {
                            float2 uv : TEXCOORD0;
                            UNITY_FOG_COORDS(1)
                            float4 vertex : SV_POSITION;
                            float3 normal : TEXCOORD2;
                        };



                        sampler2D _MainTex;
                        float4 _MainTex_ST;



                        v2f vert(appdata v)
                        {
                            v2f o;
                            o.vertex = UnityObjectToClipPos(v.vertex);
                            o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                            UNITY_TRANSFER_FOG(o,o.vertex);
                            o.normal = v.normal;
                            return o;
                        }



                        fixed4 frag(v2f i) : SV_Target
                        {
                            float3 normal = i.normal;

                            fixed4 col = 1.0;
                            col.rgb = normal;
                            return col;
                        }
                        ENDCG
                    }
    }
}