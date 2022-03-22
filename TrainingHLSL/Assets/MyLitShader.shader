Shader "Unlit/MyLitShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _DiffuseColor("DiffColor", Color) = (1,1,1,1)
        _SpecularColor("SpecColor", Color) = (1,1,1,1)
        _AmbientColor("AmbientColor", Color) = (1,1,1,1)
        _SpecularHardness("Specular hardness", Float) = 1.0
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
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float3 worldSpacePos : TEXCOORD2;
                float3 normalWS : TEXCOORD3;
                float3 viewDir : TEXCOORD4;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float3 _DiffuseColor;
            float3 _SpecularColor;
            float3 _AmbientColor;
            float _SpecularHardness;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldSpacePos = mul(unity_ObjectToWorld, v.vertex);
                o.normalWS = mul(unity_ObjectToWorld, v.normal);
                o.viewDir = mul(unity_ObjectToWorld, ObjSpaceViewDir(v.vertex));
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float3 lightPos = float3(5,10,0);
                float3 lightCol = float3(1,1,1);
                float lightStrength = 15.;
                float lightDepth = distance(lightPos, i.worldSpacePos);
                float3 lightDir = normalize(lightPos - i.worldSpacePos);
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);

                float3 diffRefl = lightCol * _DiffuseColor * saturate(dot(lightDir, i.normalWS)) * lightStrength / lightDepth;
                col.xyz = diffRefl;
                float3 H = normalize(-i.viewDir + -(lightPos - i.worldSpacePos));
                lightCol = saturate(lightCol - diffRefl);
                col.xyz += lightCol*_SpecularColor * pow(saturate(-dot(H, i.normalWS)), _SpecularHardness)* lightStrength /lightDepth;
                col.xyz += _AmbientColor;
                //col.xyz = i.normalWS;
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
