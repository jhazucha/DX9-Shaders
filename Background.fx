//*****************************************************************************
//  Techniques for rendering the various background visualizations.
//*****************************************************************************

float4x4 WorldViewProjMatrix;

float3 PlayerPosition;
float BackgroundBrightness;
//*****************************************************************************
struct VSInput
{
  float2 position	: POSITION;
	float4 color	: COLOR;
	float2 quadPosition : TEXCOORD0;
};

struct VSOutput
{
    float4 position : POSITION;
	float4 color	: COLOR;
};

//*****************************************************************************
VSOutput BackgroundVS( VSInput vsIn )
{
  VSOutput vsOut = ( VSOutput )0;

  //Transform the position into world coordinates.
  vsOut.position = mul( float4( vsIn.position.x, vsIn.position.y, 0, 1 ), WorldViewProjMatrix );

  vsOut.color = vsIn.color;

  float2 distance = PlayerPosition.xy - vsIn.quadPosition;
  float alpha = max(0, min( 0.05, (200 - length(distance))/200))*BackgroundBrightness;
  vsOut.color.a += alpha;
  return vsOut;
}

float4 BackgroundPS( VSOutput input ) : COLOR0
{
    return input.color;
}

//*****************************************************************************
technique BackgroundTech
{
    pass P0
    {
        VertexShader = compile vs_1_1 BackgroundVS( );
        PixelShader = compile ps_1_1 BackgroundPS( );
    }
}