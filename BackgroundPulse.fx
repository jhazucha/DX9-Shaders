//*****************************************************************************
//  Techniques for rendering the various background visualizations.
//*****************************************************************************

float4x4 WorldViewProjMatrix;

//*****************************************************************************
struct VSInput
{
    float3 position	: POSITION;
	float4 color	: COLOR;
};

struct VSOutput
{
    float4 position : POSITION;
	float4 color	: COLOR;
};

//*****************************************************************************
VSOutput BackgroundPulseVS( VSInput vsIn )
{
    VSOutput vsOut = ( VSOutput )0;

	//Transform the position into world coordinates.
	vsOut.position.x = ( vsIn.position.x/( 1280/2.0 ) ) - 1;
	vsOut.position.y = -( vsIn.position.y/( 1024/2.0 ) ) + 1;
	vsOut.position.z = vsIn.position.z;
	vsOut.position.w = 1;

	vsOut.color = vsIn.color;

    return vsOut;
}

float4 BackgroundPulsePS( VSOutput input ) : COLOR0
{
    return input.color;
}

//*****************************************************************************
technique BackgroundTech
{
    pass P0
    {
        VertexShader = compile vs_1_1 BackgroundPulseVS( );
        PixelShader = compile ps_1_1 BackgroundPulsePS( );
    }
}