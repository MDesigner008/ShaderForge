Shader "Hidden/Shader Forge/SFN_Fresnel_REQONLY" {
    Properties {
        _OutputMask ("Output Mask", Vector) = (1,1,1,1)
        _NRM ("Nrm", 2D) = "black" {}
        _EXP ("Exp", 2D) = "black" {}
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        Pass {
        CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma target 3.0
            uniform float4 _OutputMask;
            uniform sampler2D _NRM;
            uniform sampler2D _EXP;

            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv = v.texcoord0;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex );
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {

                // Read inputs
                float4 _nrm = tex2D( _NRM, i.uv );
                float4 _exp = tex2D( _EXP, i.uv );

                // Operator
                float4 outputColor = 1.0-max(0,dot(normalDirection, viewDirection));

                // Return
                return outputColor * _OutputMask;
            }
            ENDCG
        }
    }
}
